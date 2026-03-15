import '../entities/account_summary.dart';
import '../entities/sms_message.dart';
import '../repositories/sms_repository.dart';

class DashboardData {
  const DashboardData({required this.messages, required this.accounts});

  final List<SmsMessage> messages;
  final List<AccountSummary> accounts;
}

class LoadDashboardUseCase {
  LoadDashboardUseCase(this._repository);

  final SmsRepository _repository;

  Future<DashboardData> call({
    required int limit,
    required String countryCode,
  }) async {
    final messages = await _repository.loadStored(
      limit: limit,
      countryCode: countryCode,
    );
    final accounts = await _repository.loadAccounts(countryCode: countryCode);
    return DashboardData(messages: messages, accounts: accounts);
  }
}
