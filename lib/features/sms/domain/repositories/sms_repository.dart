import '../entities/account_summary.dart';
import '../entities/sms_message.dart';

abstract interface class SmsRepository {
  Future<List<SmsMessage>> readLatestFromDevice({required int limit});
  Future<void> sendDirectSms({required String address, required String body});
  Stream<SmsMessage> incomingSms();

  Future<void> replaceRaw(
    List<SmsMessage> messages, {
    required String countryCode,
  });
  Future<void> saveIncoming(
    SmsMessage message, {
    required int limit,
    required String countryCode,
  });

  Future<List<SmsMessage>> loadStored({
    required int limit,
    required String countryCode,
  });
  Future<void> rebuildAccounts({required String countryCode});
  Future<void> upsertAccount(SmsMessage message, {required String countryCode});
  Future<List<AccountSummary>> loadAccounts({required String countryCode});
}
