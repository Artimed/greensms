enum OperationType {
  incoming,
  outgoing,
  transfer,
  unknown;

  String get dbValue => name;

  String get titleRu {
    return switch (this) {
      OperationType.incoming => 'Зачисление',
      OperationType.outgoing => 'Списание',
      OperationType.transfer => 'Перевод',
      OperationType.unknown => 'Неизвестно',
    };
  }

  String get shortRu {
    return switch (this) {
      OperationType.incoming => 'зачисление',
      OperationType.outgoing => 'списание',
      OperationType.transfer => 'перевод',
      OperationType.unknown => 'неизвестно',
    };
  }

  static OperationType fromDb(String? value) {
    return OperationType.values.firstWhere(
      (item) => item.dbValue == value,
      orElse: () => OperationType.unknown,
    );
  }
}
