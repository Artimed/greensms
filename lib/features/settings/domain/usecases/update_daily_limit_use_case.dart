import '../repositories/settings_repository.dart';

class UpdateDailyLimitUseCase {
  UpdateDailyLimitUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(double? limit) => _repository.updateDailyLimit(limit);
}
