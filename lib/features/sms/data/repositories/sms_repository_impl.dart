import '../../domain/entities/account_summary.dart';
import '../../domain/entities/sms_message.dart';
import '../../domain/repositories/sms_repository.dart';
import '../datasources/sms_local_data_source.dart';
import '../datasources/sms_native_data_source.dart';

class SmsRepositoryImpl implements SmsRepository {
  SmsRepositoryImpl({
    required SmsNativeDataSource native,
    required SmsLocalDataSource local,
  }) : _native = native,
       _local = local;

  final SmsNativeDataSource _native;
  final SmsLocalDataSource _local;

  @override
  Stream<SmsMessage> incomingSms() => _native.incomingSms();

  @override
  Future<List<SmsMessage>> readLatestFromDevice({required int limit}) {
    return _native.readLatest(limit: limit);
  }

  @override
  Future<void> sendDirectSms({required String address, required String body}) {
    return _native.sendDirectSms(address: address, body: body);
  }

  @override
  Future<void> rebuildAccounts({required String countryCode}) =>
      _local.rebuildAccounts(countryCode: countryCode);

  @override
  Future<void> replaceRaw(
    List<SmsMessage> messages, {
    required String countryCode,
  }) => _local.replaceRaw(messages, countryCode: countryCode);

  @override
  Future<void> saveIncoming(
    SmsMessage message, {
    required int limit,
    required String countryCode,
  }) {
    return _local.saveIncoming(message, limit: limit, countryCode: countryCode);
  }

  @override
  Future<List<AccountSummary>> loadAccounts({required String countryCode}) =>
      _local.loadAccounts(countryCode: countryCode);

  @override
  Future<List<SmsMessage>> loadStored({
    required int limit,
    required String countryCode,
  }) {
    return _local.loadStored(limit: limit, countryCode: countryCode);
  }

  @override
  Future<void> upsertAccount(
    SmsMessage message, {
    required String countryCode,
  }) => _local.upsertAccount(message, countryCode: countryCode);
}
