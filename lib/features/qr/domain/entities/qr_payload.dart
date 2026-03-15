import 'dart:convert';

import 'package:crypto/crypto.dart';

enum QrRecipientType { phone, account }

class QrPayload {
  const QrPayload({
    required this.recipientValue,
    this.recipientType = QrRecipientType.phone,
    this.amount,
    this.sourceLast4,
    this.note,
    this.profileName,
    this.bankId,
    this.routeId,
  });

  final String recipientValue;
  final QrRecipientType recipientType;
  final double? amount;
  final String? sourceLast4;
  final String? note;
  final String? profileName;
  final String? bankId;
  final String? routeId;

  String get phone => recipientValue;

  QrPayload copyWith({
    String? recipientValue,
    QrRecipientType? recipientType,
    double? amount,
    String? sourceLast4,
    String? note,
    String? profileName,
    String? bankId,
    String? routeId,
  }) {
    return QrPayload(
      recipientValue: recipientValue ?? this.recipientValue,
      recipientType: recipientType ?? this.recipientType,
      amount: amount ?? this.amount,
      sourceLast4: sourceLast4 ?? this.sourceLast4,
      note: note ?? this.note,
      profileName: profileName ?? this.profileName,
      bankId: bankId ?? this.bankId,
      routeId: routeId ?? this.routeId,
    );
  }

  static const String _prefixV4 = 'greensms://qr/v4/';
  static const String _prefixV3 = 'greensms://qr/v3/';
  static const String _legacyPrefixV2 = 'greensms://qr/v2/';
  static const String _appTag = 'zelenaya_sms';
  static const String _legacyPepper = 'greensms_v2_local_payload';
  static const String _hmacKeySeed = 'greensms_v3_hmac_local_payload_key';
  static final List<int> _hmacKey = utf8.encode(_hmacKeySeed);
  static const int _signatureBytes = 16;

  String encode() {
    final payloadMap = <String, dynamic>{
      'a': _appTag,
      'v': 4,
      'r': recipientValue,
      't': recipientType.name,
    };
    if (amount != null) {
      payloadMap['m'] = amount;
    }
    if (sourceLast4 != null && sourceLast4!.isNotEmpty) {
      payloadMap['s'] = sourceLast4;
    }
    if (note != null && note!.isNotEmpty) {
      payloadMap['n'] = note;
    }
    if (profileName != null && profileName!.isNotEmpty) {
      payloadMap['p'] = profileName;
    }
    if (bankId != null && bankId!.isNotEmpty) {
      payloadMap['b'] = bankId;
    }
    if (routeId != null && routeId!.isNotEmpty) {
      payloadMap['d'] = routeId;
    }
    final payload = jsonEncode(payloadMap);
    final body = base64UrlEncode(utf8.encode(payload)).replaceAll('=', '');
    final signature = _hmacSha256Hex(body);
    return '$_prefixV4$body.$signature';
  }

  static QrPayload? decode(String raw) {
    try {
      if (raw.startsWith(_prefixV4)) {
        return _decodeSigned(
          raw: raw,
          prefix: _prefixV4,
          expectedVersion: 4,
          signBody: _hmacSha256Hex,
          constantTimeCompare: true,
        );
      }
      if (raw.startsWith(_prefixV3)) {
        return _decodeSigned(
          raw: raw,
          prefix: _prefixV3,
          expectedVersion: 3,
          signBody: _hmacSha256Hex,
          constantTimeCompare: true,
        );
      }
      if (raw.startsWith(_legacyPrefixV2)) {
        return _decodeSigned(
          raw: raw,
          prefix: _legacyPrefixV2,
          expectedVersion: 2,
          signBody: (body) => _fnv1a32Hex('$body|$_legacyPepper'),
          constantTimeCompare: false,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static QrPayload? _decodeSigned({
    required String raw,
    required String prefix,
    required int expectedVersion,
    required String Function(String body) signBody,
    required bool constantTimeCompare,
  }) {
    final encodedAndSig = raw.substring(prefix.length);
    final splitIndex = encodedAndSig.lastIndexOf('.');
    if (splitIndex <= 0 || splitIndex == encodedAndSig.length - 1) {
      return null;
    }

    final body = encodedAndSig.substring(0, splitIndex);
    final signature = encodedAndSig.substring(splitIndex + 1).toLowerCase();
    final expectedSignature = signBody(body);
    final isValidSignature = constantTimeCompare
        ? _constantTimeEquals(signature, expectedSignature)
        : signature == expectedSignature;
    if (!isValidSignature) {
      return null;
    }

    final normalizedBody = base64Url.normalize(body);
    final decoded = jsonDecode(utf8.decode(base64Url.decode(normalizedBody)));
    if (decoded is! Map) {
      return null;
    }

    final payload = Map<String, dynamic>.from(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
    return _fromDecodedMap(payload, expectedVersion);
  }

  static QrPayload? _fromDecodedMap(
    Map<String, dynamic> decoded,
    int expectedVersion,
  ) {
    final appTag = decoded['a']?.toString() ?? decoded['app']?.toString();
    if (appTag != _appTag) {
      return null;
    }
    if ((decoded['v'] as num?)?.toInt() != expectedVersion) {
      return null;
    }

    final amountRaw = decoded['m'] ?? decoded['amount'];
    final amount = switch (amountRaw) {
      num _ => amountRaw.toDouble(),
      String _ => double.tryParse(amountRaw.replaceAll(',', '.')),
      _ => null,
    };
    final sourceLast4 = _normalizeLast4(
      decoded['s']?.toString() ?? decoded['sourceLast4']?.toString(),
    );

    if (expectedVersion == 4) {
      final recipientValue = decoded['r']?.toString();
      if (recipientValue == null || recipientValue.isEmpty) {
        return null;
      }
      final recipientTypeRaw = decoded['t']?.toString().toLowerCase();
      final recipientType = recipientTypeRaw == QrRecipientType.account.name
          ? QrRecipientType.account
          : QrRecipientType.phone;

      return QrPayload(
        recipientValue: recipientValue,
        recipientType: recipientType,
        amount: amount,
        sourceLast4: sourceLast4,
        note: decoded['n']?.toString() ?? decoded['note']?.toString(),
        profileName:
            decoded['p']?.toString() ?? decoded['profileName']?.toString(),
        bankId: decoded['b']?.toString(),
        routeId: decoded['d']?.toString(),
      );
    }

    final phone = decoded['p']?.toString() ?? decoded['phone']?.toString();
    if (phone == null || phone.isEmpty) {
      return null;
    }

    return QrPayload(
      recipientValue: phone,
      recipientType: QrRecipientType.phone,
      amount: amount,
      sourceLast4: sourceLast4,
      note: decoded['n']?.toString() ?? decoded['note']?.toString(),
      profileName:
          decoded['r']?.toString() ?? decoded['profileName']?.toString(),
    );
  }

  static String? _normalizeLast4(String? raw) {
    if (raw == null) {
      return null;
    }
    final digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length != 4) {
      return null;
    }
    return digits;
  }

  static String _hmacSha256Hex(String input) {
    final mac = Hmac(sha256, _hmacKey).convert(utf8.encode(input)).bytes;
    final truncated = mac.take(_signatureBytes);
    return truncated
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static bool _constantTimeEquals(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);
    if (aBytes.length != bBytes.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < aBytes.length; i++) {
      diff |= aBytes[i] ^ bBytes[i];
    }
    return diff == 0;
  }

  static String _fnv1a32Hex(String input) {
    const int offsetBasis = 0x811c9dc5;
    const int prime = 0x01000193;

    var hash = offsetBasis;
    for (final byte in utf8.encode(input)) {
      hash ^= byte;
      hash = (hash * prime) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}
