import '../repositories/qr_repository.dart';

class LoadTodayUsedAmountUseCase {
  LoadTodayUsedAmountUseCase(this._repository);

  final QrRepository _repository;

  Future<double> call({required String countryCode}) =>
      _repository.loadTodayUsedAmount(countryCode: countryCode);
}
