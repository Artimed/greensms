import 'package:flutter/material.dart';

import '../../../../app/app_controller.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/services/bank/bank_registry_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../sms/presentation/transfer_limits_page.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.bankRegistry,
  });

  final AppController controller;
  final Future<void> Function() onRefresh;
  final BankRegistryService bankRegistry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.greenDark, AppColors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/icons/app_icon_source.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.appName,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _openLimitsInfo(context),
                icon: Icon(
                  Icons.info_outline,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                tooltip: l10n.transferRulesTooltip,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatChip(
                label: 'SMS',
                value: '${controller.messages.length}',
                icon: Icons.message_outlined,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              _StatChip(
                label: l10n.accountsLabel,
                value: '${controller.accounts.length}',
                icon: Icons.credit_card_outlined,
                colorScheme: colorScheme,
              ),
              const Spacer(),
              if (controller.lastUpdated != null)
                Text(
                  Formatters.dateTime(controller.lastUpdated!),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
          if (controller.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      controller.errorMessage!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          GradientButton(
            onPressed: controller.isBusy ? null : onRefresh,
            icon: controller.isBusy
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text(l10n.refreshSmsButton),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  void _openLimitsInfo(BuildContext context) {
    final bankId = controller.settings.selectedBankId;
    final bank = bankId != null ? bankRegistry.getBankById(bankId) : null;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TransferLimitsPage(bank: bank),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 4),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
