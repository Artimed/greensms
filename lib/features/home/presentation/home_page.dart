import 'package:flutter/material.dart';

import '../../../app/app_controller.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/operation_type_l10n.dart';
import '../../../core/services/bank/bank_registry_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../sms/domain/entities/sms_message.dart';
import 'widgets/account_tile.dart';
import 'widgets/daily_limit_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/sms_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.bankRegistry,
    required this.onOpenQr,
    required this.onOpenSettings,
  });

  final AppController controller;
  final BankRegistryService bankRegistry;
  final VoidCallback onOpenQr;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currencyCode = _activeCurrencyCode();

    return RefreshIndicator(
      onRefresh: controller.refreshSmsFromDevice,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DashboardHeader(
            controller: controller,
            onRefresh: controller.refreshSmsFromDevice,
            bankRegistry: bankRegistry,
          ),
          const SizedBox(height: 12),
          DailyLimitCard(
            controller: controller,
            currencyCode: currencyCode,
            onOpenSettings: onOpenSettings,
          ),
          const SizedBox(height: 12),
          _QrBanner(onTap: onOpenQr),
          const SizedBox(height: 20),
          Text(l10n.accounts, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (controller.accounts.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.noAccountsYet),
              ),
            ),
          ...controller.accounts.map(
            (account) =>
                AccountTile(account: account, currencyCode: currencyCode),
          ),
          const SizedBox(height: 20),
          Text(l10n.latestSms, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (controller.messages.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.smsNotLoaded),
              ),
            ),
          ...controller.messages.map(
            (sms) => SmsTile(
              sms: sms,
              currencyCode: currencyCode,
              onTap: () => _showSmsDetails(context, sms, currencyCode),
            ),
          ),
        ],
      ),
    );
  }

  String _activeCurrencyCode() {
    final selectedBankId = controller.settings.selectedBankId;
    if (selectedBankId != null && selectedBankId.isNotEmpty) {
      final selectedBank = bankRegistry.getBankById(selectedBankId);
      if (selectedBank != null) {
        return selectedBank.currency;
      }
    }

    final selectedCountryCode = controller.settings.selectedCountryCode;
    if (selectedCountryCode != null && selectedCountryCode.isNotEmpty) {
      final selectedCountry = bankRegistry.getCountryByCode(
        selectedCountryCode,
      );
      if (selectedCountry != null) {
        return selectedCountry.currency;
      }
    }

    return 'RUB';
  }

  void _showSmsDetails(
    BuildContext context,
    SmsMessage sms,
    String currencyCode,
  ) {
    final l10n = context.l10n;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              l10n.smsDetailsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(l10n.smsDetailsSender(sms.sender)),
            Text(l10n.smsDetailsTime(Formatters.dateTime(sms.dateTime))),
            Text(
              l10n.smsDetailsLast4(sms.last4 ?? l10n.smsDetailsLast4NotFound),
            ),
            Text(
              l10n.smsDetailsAmount(
                Formatters.money(sms.amount, currencyCode: currencyCode),
              ),
            ),
            Text(
              l10n.smsDetailsBalance(
                Formatters.money(sms.balance, currencyCode: currencyCode),
              ),
            ),
            if (sms.reference != null && sms.reference!.isNotEmpty)
              Text(
                l10n.smsDetailsReference(sms.reference!),
              ),
            Text(l10n.smsDetailsType(sms.operationType.localizedShort(l10n))),
            const SizedBox(height: 12),
            Text(sms.body),
          ],
        ),
      ),
    );
  }
}

class _QrBanner extends StatelessWidget {
  const _QrBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.greenDark, AppColors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: Colors.white, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.qrModeTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.qrModeSubtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
