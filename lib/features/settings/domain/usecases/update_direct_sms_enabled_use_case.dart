import '../repositories/settings_repository.dart';

class UpdateDirectSmsEnabledUseCase {
  UpdateDirectSmsEnabledUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(bool value) => _repository.updateDirectSmsEnabled(value);
}
