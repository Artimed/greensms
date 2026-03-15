import '../../../../core/result/result.dart';
import '../repositories/sms_repository.dart';

class SendDirectSmsUseCase {
  SendDirectSmsUseCase(this._repository);

  final SmsRepository _repository;

  Future<Result<void>> call({
    required String address,
    required String body,
  }) async {
    try {
      await _repository.sendDirectSms(address: address, body: body);
      return const Success<void>(null);
    } catch (error) {
      return Failure<void>('Failed to send direct SMS.', error: error);
    }
  }
}
