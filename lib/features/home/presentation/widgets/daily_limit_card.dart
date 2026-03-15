import 'package:flutter/material.dart';

import '../../../../app/app_controller.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class DailyLimitCard extends StatelessWidget {
  const DailyLimitCard({
    super.key,
    required this.controller,
    required this.currencyCode,
    this.onOpenSettings,
  });

  final AppController controller;
  final String currencyCode;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final limit = controller.settings.dailyLimit;
    final used = controller.todayUsedAmount;
    final remaining = controller.dailyLimitRemaining;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (limit == null || limit <= 0) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.shield_outlined, color: colorScheme.primary),
          title: Text(l10n.dailyLimitNotSet),
          subtitle: Text(l10n.setLimitInSettings),
          trailing: IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: onOpenSettings,
          ),
        ),
      );
    }

    final progress = (used / limit).clamp(0.0, 1.0);
    final isWarning = progress >= 0.8;
    final isExceeded = progress >= 1.0;

    final barColor = isExceeded
        ? colorScheme.error
        : isWarning
        ? Colors.orange
        : AppColors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isExceeded ? Icons.warning_amber : Icons.shield_outlined,
                  color: barColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.dailyTransferLimit,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  Formatters.money(limit, currencyCode: currencyCode),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.usedToday,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      Formatters.money(
                        used > 0 ? used : null,
                        currencyCode: currencyCode,
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: used > 0 ? barColor : null,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.remaining,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      isExceeded
                          ? l10n.limitExceeded
                          : Formatters.money(
                              remaining,
                              currencyCode: currencyCode,
                            ),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isExceeded ? colorScheme.error : AppColors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isWarning && !isExceeded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.limitWarning80,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (isExceeded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: colorScheme.error, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.limitExceededBlocked,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
