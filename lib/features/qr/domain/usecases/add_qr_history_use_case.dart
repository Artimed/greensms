import '../repositories/qr_repository.dart';

class AddQrHistoryUseCase {
  AddQrHistoryUseCase(this._repository);

  final QrRepository _repository;

  Future<void> call({
    required String phone,
    required String direction,
    required String countryCode,
    double? amount,
    String? note,
    String? profileName,
  }) {
    return _repository.addHistory(
      phone: phone,
      direction: direction,
      countryCode: countryCode,
      amount: amount,
      note: note,
      profileName: profileName,
    );
  }
}
