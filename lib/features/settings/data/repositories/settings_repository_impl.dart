import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<AppSettings> load() => _localDataSource.load();

  @override
  Future<void> updateOnboardingDone(bool value) {
    return _localDataSource.updateOnboardingDone(value);
  }

  @override
  Future<void> updateDevicePhone(String phone) {
    return _localDataSource.updateDevicePhone(phone);
  }

  @override
  Future<void> updateDirectSmsEnabled(bool value) {
    return _localDataSource.updateDirectSmsEnabled(value);
  }

  @override
  Future<void> updateDirectSmsConfigured(bool value) {
    return _localDataSource.updateDirectSmsConfigured(value);
  }

  @override
  Future<void> updateSelectedCountryCode(String? countryCode) {
    return _localDataSource.updateSelectedCountryCode(countryCode);
  }

  @override
  Future<void> updateSelectedBankId(String? bankId) {
    return _localDataSource.updateSelectedBankId(bankId);
  }

  @override
  Future<void> updateDailyLimit(double? limit) {
    return _localDataSource.updateDailyLimit(limit);
  }

  @override
  Future<void> updateThemeMode(String mode) {
    return _localDataSource.updateThemeMode(mode);
  }

  @override
  Future<void> updateLocaleCode(String code) {
    return _localDataSource.updateLocaleCode(code);
  }
}
