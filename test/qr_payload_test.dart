import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/qr/domain/entities/qr_payload.dart';

const _legacyPrefixV2 = 'greensms://qr/v2/';
const _legacyPepper = 'greensms_v2_local_payload';

void main() {
  group('QrPayload signed format', () {
    test('encodes and decodes valid internal payload', () {
      const payload = QrPayload(
        recipientValue: '+79991234567',
        amount: 1500,
        sourceLast4: '1234',
        note: 'For lunch',
        profileName: 'Alex',
      );

      final encoded = payload.encode();
      final decoded = QrPayload.decode(encoded);

      expect(encoded.startsWith('greensms://qr/v4/'), isTrue);
      expect(decoded, isNotNull);
      expect(decoded!.recipientValue, payload.recipientValue);
      expect(decoded.recipientType, QrRecipientType.phone);
      expect(decoded.amount, payload.amount);
      expect(decoded.sourceLast4, payload.sourceLast4);
      expect(decoded.note, payload.note);
      expect(decoded.profileName, payload.profileName);
    });

    test('encodes and decodes account-based payload', () {
      const payload = QrPayload(
        recipientValue: '0123456789',
        recipientType: QrRecipientType.account,
        amount: 3200,
        bankId: 'gtbank_ng',
        routeId: 'gtbank_ng:ussd:account',
      );

      final encoded = payload.encode();
      final decoded = QrPayload.decode(encoded);

      expect(decoded, isNotNull);
      expect(decoded!.recipientValue, '0123456789');
      expect(decoded.recipientType, QrRecipientType.account);
      expect(decoded.bankId, 'gtbank_ng');
      expect(decoded.routeId, 'gtbank_ng:ussd:account');
      expect(decoded.amount, 3200);
    });

    test('decodes legacy v2 payload for backward compatibility', () {
      final legacyPayload = jsonEncode({
        'app': 'zelenaya_sms',
        'v': 2,
        'phone': '+79990001122',
        'amount': 2500,
        'note': 'Legacy',
        'profileName': 'V2',
      });
      final body = base64UrlEncode(
        utf8.encode(legacyPayload),
      ).replaceAll('=', '');
      final sig = _fnv1a32Hex('$body|$_legacyPepper');
      final encoded = '$_legacyPrefixV2$body.$sig';

      final decoded = QrPayload.decode(encoded);

      expect(decoded, isNotNull);
      expect(decoded!.phone, '+79990001122');
      expect(decoded.amount, 2500);
      expect(decoded.sourceLast4, isNull);
      expect(decoded.note, 'Legacy');
      expect(decoded.profileName, 'V2');
    });

    test('rejects old plain JSON payload', () {
      final old = jsonEncode({'phone': '+79991234567', 'amount': 100, 'v': 1});

      expect(QrPayload.decode(old), isNull);
    });

    test('rejects tampered payload signature', () {
      const payload = QrPayload(recipientValue: '+79991234567', amount: 10);
      final encoded = payload.encode();
      final tampered = '${encoded}x';

      expect(QrPayload.decode(tampered), isNull);
    });
  });
}

String _fnv1a32Hex(String input) {
  const int offsetBasis = 0x811c9dc5;
  const int prime = 0x01000193;

  var hash = offsetBasis;
  for (final byte in utf8.encode(input)) {
    hash ^= byte;
    hash = (hash * prime) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
