import '../repositories/settings_repository.dart';

class UpdateThemeModeUseCase {
  UpdateThemeModeUseCase(this._repository);
  final SettingsRepository _repository;
  Future<void> call(String mode) => _repository.updateThemeMode(mode);
}
