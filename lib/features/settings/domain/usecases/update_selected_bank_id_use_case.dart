import '../repositories/settings_repository.dart';

class UpdateSelectedBankIdUseCase {
  UpdateSelectedBankIdUseCase(this._repository);
  final SettingsRepository _repository;
  Future<void> call(String? bankId) => _repository.updateSelectedBankId(bankId);
}
