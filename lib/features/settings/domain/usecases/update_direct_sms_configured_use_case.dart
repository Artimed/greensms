import '../repositories/settings_repository.dart';

class UpdateDirectSmsConfiguredUseCase {
  UpdateDirectSmsConfiguredUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(bool value) => _repository.updateDirectSmsConfigured(value);
}
