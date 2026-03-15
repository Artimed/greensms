import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> load();
  Future<void> updateOnboardingDone(bool value);
  Future<void> updateDevicePhone(String phone);
  Future<void> updateDirectSmsEnabled(bool value);
  Future<void> updateDirectSmsConfigured(bool value);
  Future<void> updateSelectedCountryCode(String? countryCode);
  Future<void> updateSelectedBankId(String? bankId);
  Future<void> updateDailyLimit(double? limit);
  Future<void> updateThemeMode(String mode);
  Future<void> updateLocaleCode(String code);
}
