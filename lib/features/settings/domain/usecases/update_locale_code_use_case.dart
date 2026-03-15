import '../repositories/settings_repository.dart';

class UpdateLocaleCodeUseCase {
  UpdateLocaleCodeUseCase(this._repository);
  final SettingsRepository _repository;
  Future<void> call(String code) => _repository.updateLocaleCode(code);
}
