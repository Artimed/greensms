import '../../../../core/result/result.dart';
import '../entities/operation_type.dart';
import '../entities/sms_message.dart';
import '../repositories/sms_repository.dart';

class HandleIncomingSmsUseCase {
  HandleIncomingSmsUseCase(this._repository);

  final SmsRepository _repository;

  Future<Result<void>> call(
    SmsMessage message, {
    required int limit,
    required String countryCode,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    if (normalizedCountry != 'RU') {
      return const Success<void>(null);
    }

    // Do not store OTP and non-transactional service SMS.
    if (message.isOtp) return const Success<void>(null);
    final isTransactional =
        message.operationType != OperationType.unknown ||
        (message.last4 != null && message.amount != null);
    if (!isTransactional) return const Success<void>(null);
    try {
      await _repository.saveIncoming(
        message,
        limit: limit,
        countryCode: normalizedCountry,
      );
      await _repository.upsertAccount(message, countryCode: normalizedCountry);
      return const Success<void>(null);
    } catch (error) {
      return Failure<void>('Failed to save incoming SMS.', error: error);
    }
  }
}
