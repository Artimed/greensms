import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../sms/domain/entities/operation_type.dart';
import '../../../sms/domain/entities/sms_message.dart';

class SmsTile extends StatelessWidget {
  const SmsTile({
    super.key,
    required this.sms,
    required this.onTap,
    required this.currencyCode,
  });

  final SmsMessage sms;
  final VoidCallback onTap;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final opColor = _colorForType(sms.operationType, colorScheme);
    final metaParts = <String>['**${sms.last4 ?? '----'}'];
    if (sms.reference != null && sms.reference!.isNotEmpty) {
      metaParts.add(l10n.smsDetailsReference(sms.reference!));
    }
    metaParts.add(sms.parsed ? l10n.parsedLabel : l10n.rawLabel);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: opColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _iconForType(sms.operationType),
                  color: opColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _signedAmount(
                        sms.amount,
                        sms.operationType,
                        currencyCode,
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: opColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      metaParts.join(' · '),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.time(sms.dateTime),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  if (sms.balance != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      Formatters.money(sms.balance, currencyCode: currencyCode),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(OperationType type) {
    return switch (type) {
      OperationType.incoming => Icons.south_west,
      OperationType.outgoing => Icons.north_east,
      OperationType.transfer => Icons.swap_horiz,
      OperationType.unknown => Icons.help_outline,
    };
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
