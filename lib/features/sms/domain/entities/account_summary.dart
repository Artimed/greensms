import 'operation_type.dart';

class AccountSummary {
  const AccountSummary({
    this.id,
    required this.last4,
    required this.updatedAt,
    required this.lastOperationType,
    this.sender,
    this.lastBalance,
    this.lastAmount,
  });

  final int? id;
  final String last4;
  final String? sender;
  final double? lastBalance;
  final double? lastAmount;
  final OperationType lastOperationType;
  final DateTime updatedAt;

  AccountSummary copyWith({
    int? id,
    String? last4,
    String? sender,
    double? lastBalance,
    double? lastAmount,
    OperationType? lastOperationType,
    DateTime? updatedAt,
  }) {
    return AccountSummary(
      id: id ?? this.id,
      last4: last4 ?? this.last4,
      sender: sender ?? this.sender,
      lastBalance: lastBalance ?? this.lastBalance,
      lastAmount: lastAmount ?? this.lastAmount,
      lastOperationType: lastOperationType ?? this.lastOperationType,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toDbMap() {
    return {
      'id': id,
      'last4': last4,
      'sender': sender,
      'last_balance': lastBalance,
      'last_amount': lastAmount,
      'last_operation_type': lastOperationType.dbValue,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory AccountSummary.fromDbMap(Map<String, Object?> map) {
    return AccountSummary(
      id: map['id'] as int?,
      last4: (map['last4'] as String?) ?? '0000',
      sender: map['sender'] as String?,
      lastBalance: (map['last_balance'] as num?)?.toDouble(),
      lastAmount: (map['last_amount'] as num?)?.toDouble(),
      lastOperationType: OperationType.fromDb(
        map['last_operation_type'] as String?,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updated_at'] as int?) ?? 0,
      ),
    );
  }
}
