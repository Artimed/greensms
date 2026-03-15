abstract interface class QrRepository {
  Future<List<String>> loadRecentRecipients({
    required String countryCode,
    int limit,
  });
  Future<void> addHistory({
    required String phone,
    required String direction,
    required String countryCode,
    double? amount,
    String? note,
    String? profileName,
  });
  Future<double> loadTodayUsedAmount({required String countryCode});
  Future<void> clearData();
}
