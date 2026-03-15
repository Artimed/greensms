import '../../../../core/result/result.dart';
import '../../data/parsing/sms_parser.dart';
import '../entities/operation_type.dart';
import '../entities/sms_message.dart';
import '../repositories/sms_repository.dart';

class RefreshSmsUseCase {
  RefreshSmsUseCase({
    required SmsRepository repository,
    required SmsParser parser,
  }) : _repository = repository,
       _parser = parser;

  final SmsRepository _repository;
  final SmsParser _parser;

  /// SMS is considered transactional if operation is recognized OR card+amount
  /// are present. Service messages are ignored.
  static bool _isTransactional(SmsMessage m) =>
      m.operationType != OperationType.unknown ||
      (m.last4 != null && m.amount != null);

  Future<Result<void>> call({
    required int limit,
    required String countryCode,
  }) async {
    try {
      final normalizedCountry = countryCode.trim().toUpperCase();
      // Until non-RU sender registries are wired to the native bridge,
      // do not import 900-SMS into other country contexts.
      if (normalizedCountry != 'RU') {
        await _repository.replaceRaw(
          const <SmsMessage>[],
          countryCode: normalizedCountry,
        );
        await _repository.rebuildAccounts(countryCode: normalizedCountry);
        return const Success<void>(null);
      }

      // Read a larger batch first (platform side already filters sender='900'),
      // then parse, skip OTP, and keep the first transactional `limit` messages.
      final raw = await _repository.readLatestFromDevice(limit: limit);
      final parsed = raw
          .map(_parser.parse)
          .where((m) => !m.isOtp && _isTransactional(m))
          .take(limit)
          .toList();
      await _repository.replaceRaw(parsed, countryCode: normalizedCountry);
      await _repository.rebuildAccounts(countryCode: normalizedCountry);
      return const Success<void>(null);
    } catch (error) {
      return Failure<void>('Failed to refresh SMS from device.', error: error);
    }
  }
}
