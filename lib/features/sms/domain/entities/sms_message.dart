import 'operation_type.dart';

class SmsMessage {
  const SmsMessage({
    this.id,
    required this.sender,
    required this.body,
    required this.dateTime,
    required this.parsed,
    required this.operationType,
    this.last4,
    this.amount,
    this.balance,
    this.reference,
    this.isOtp = false,
  });

  final int? id;
  final String sender;
  final String body;
  final DateTime dateTime;
  final bool parsed;
  final String? last4;
  final double? amount;
  final double? balance;
  final String? reference;
  final OperationType operationType;
  final bool isOtp;

  SmsMessage copyWith({
    int? id,
    String? sender,
    String? body,
    DateTime? dateTime,
    bool? parsed,
    String? last4,
    double? amount,
    double? balance,
    String? reference,
    OperationType? operationType,
    bool? isOtp,
  }) {
    return SmsMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      parsed: parsed ?? this.parsed,
      last4: last4 ?? this.last4,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      reference: reference ?? this.reference,
      operationType: operationType ?? this.operationType,
      isOtp: isOtp ?? this.isOtp,
    );
  }

  Map<String, Object?> toDbMap() {
    return {
      'id': id,
      'sender': sender,
      'body': body,
      'date_time': dateTime.millisecondsSinceEpoch,
      'parsed': parsed ? 1 : 0,
      'last4': last4,
      'amount': amount,
      'balance': balance,
      'reference': reference,
      'operation_type': operationType.dbValue,
      'is_otp': isOtp ? 1 : 0,
    };
  }

  factory SmsMessage.fromDbMap(Map<String, Object?> map) {
    return SmsMessage(
      id: map['id'] as int?,
      sender: (map['sender'] as String?) ?? 'unknown',
      body: (map['body'] as String?) ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (map['date_time'] as int?) ?? 0,
      ),
      parsed: ((map['parsed'] as int?) ?? 0) == 1,
      last4: map['last4'] as String?,
      amount: (map['amount'] as num?)?.toDouble(),
      balance: (map['balance'] as num?)?.toDouble(),
      reference: map['reference'] as String?,
      operationType: OperationType.fromDb(map['operation_type'] as String?),
      isOtp: ((map['is_otp'] as int?) ?? 0) == 1,
    );
  }

  factory SmsMessage.fromNative(Map<Object?, Object?> map) {
    return SmsMessage(
      sender: (map['sender'] as String?) ?? 'unknown',
      body: (map['body'] as String?) ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        ((map['dateTimeMillis'] as num?) ?? 0).toInt(),
      ),
      parsed: false,
      operationType: OperationType.unknown,
    );
  }
}
