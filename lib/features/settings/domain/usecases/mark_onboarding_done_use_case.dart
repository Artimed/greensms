import '../repositories/settings_repository.dart';

class MarkOnboardingDoneUseCase {
  MarkOnboardingDoneUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call() => _repository.updateOnboardingDone(true);
}
