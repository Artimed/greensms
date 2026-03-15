import '../repositories/settings_repository.dart';

class UpdateSelectedCountryCodeUseCase {
  UpdateSelectedCountryCodeUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> call(String? countryCode) =>
      _repository.updateSelectedCountryCode(countryCode);
}
