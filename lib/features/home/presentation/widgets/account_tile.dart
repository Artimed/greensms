import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../sms/domain/entities/account_summary.dart';
import '../../../sms/domain/entities/operation_type.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.account,
    required this.currencyCode,
  });

  final AccountSummary account;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final opColor = _colorForType(account.lastOperationType, colorScheme);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  account.last4,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '**${account.last4}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.accountBalanceLabel(
                      Formatters.money(
                        account.lastBalance,
                        currencyCode: currencyCode,
                      ),
                    ),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _signedAmount(
                    account.lastAmount,
                    account.lastOperationType,
                    currencyCode,
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: opColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.time(account.updatedAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForType(OperationType type, ColorScheme scheme) {
    return switch (type) {
      OperationType.incoming => AppColors.green,
      OperationType.outgoing => scheme.error,
      OperationType.transfer => scheme.primary,
      OperationType.unknown => scheme.onSurface,
    };
  }

  String _signedAmount(double? value, OperationType type, String currencyCode) {
    if (value == null) return '—';
    final sign = switch (type) {
      OperationType.incoming => '+',
      OperationType.outgoing => '-',
      OperationType.transfer => '±',
      OperationType.unknown => '',
    };
    return '$sign${Formatters.money(value, currencyCode: currencyCode)}';
  }
}
