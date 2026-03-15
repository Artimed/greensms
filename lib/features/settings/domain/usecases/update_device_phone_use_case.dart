import '../repositories/settings_repository.dart';

class UpdateDevicePhoneUseCase {
  UpdateDevicePhoneUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(String phone) => _repository.updateDevicePhone(phone);
}
