import '../repositories/qr_repository.dart';

class LoadRecentRecipientsUseCase {
  LoadRecentRecipientsUseCase(this._repository);

  final QrRepository _repository;

  Future<List<String>> call({
    required String countryCode,
    int limit = 5,
  }) =>
      _repository.loadRecentRecipients(
        countryCode: countryCode,
        limit: limit,
      );
}
