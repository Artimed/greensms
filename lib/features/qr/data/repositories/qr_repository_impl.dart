import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_local_data_source.dart';

class QrRepositoryImpl implements QrRepository {
  QrRepositoryImpl(this._localDataSource);

  final QrLocalDataSource _localDataSource;

  @override
  Future<List<String>> loadRecentRecipients({
    required String countryCode,
    int limit = 5,
  }) =>
      _localDataSource.loadRecentRecipients(
        countryCode: countryCode,
        limit: limit,
      );

  @override
  Future<void> addHistory({
    required String phone,
    required String direction,
    required String countryCode,
    double? amount,
    String? note,
    String? profileName,
  }) {
    return _localDataSource.addHistory(
      phone: phone,
      direction: direction,
      countryCode: countryCode,
      amount: amount,
      note: note,
      profileName: profileName,
    );
  }

  @override
  Future<double> loadTodayUsedAmount({required String countryCode}) =>
      _localDataSource.loadTodayUsedAmount(countryCode: countryCode);

  @override
  Future<void> clearData() => _localDataSource.clearData();
}
