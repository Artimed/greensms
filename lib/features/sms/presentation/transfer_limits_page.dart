import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/services/bank/bank_models.dart';
import '../../../core/theme/app_theme.dart';

class TransferLimitsPage extends StatelessWidget {
  const TransferLimitsPage({super.key, required this.bank});

  final BankEntry? bank;

  @override
  Widget build(BuildContext context) {
    final bank = this.bank;
    if (bank == null) return _buildNoBankPage(context);
    if (bank.bankId == 'sberbank_ru') return _buildSberbankPage(context, bank);
    return _buildGenericBankPage(context, bank);
  }

  // ── No bank selected ──────────────────────────────────────────────────────

  Widget _buildNoBankPage(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.transferLimitsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _InfoBanner(
          icon: Icons.info_outline,
          color: colorScheme.primaryContainer,
          iconColor: colorScheme.primary,
          text: l10n.noBankSelectedBanner,
        ),
      ),
    );
  }

  // ── Sberbank (full existing content) ─────────────────────────────────────

  Widget _buildSberbankPage(BuildContext context, BankEntry bank) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final officialStatusLabel = _officialStatusLabel(context, bank);
    final panelChannelLabel = _panelChannelLabel(bank.panelChannel);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transferLimitsTitle),
        actions: [
          IconButton(
            onPressed: () => _openUrl(context, 'https://www.sberbank.ru'),
            icon: const Icon(Icons.open_in_browser),
            tooltip: l10n.openSberSiteTooltip,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoBanner(
            icon: Icons.info_outline,
            color: colorScheme.primaryContainer,
            iconColor: colorScheme.primary,
            text: _sberInfoBanner(context),
          ),
          const SizedBox(height: 16),

          if (bank.isLimitedPublic) ...[
            _InfoBanner(
              icon: Icons.warning_amber,
              color: colorScheme.tertiaryContainer,
              iconColor: colorScheme.onTertiaryContainer,
              text: _limitedWarningText(context),
            ),
            const SizedBox(height: 16),
          ],

          _SectionCard(
            title: l10n.officialDataTitle,
            icon: Icons.verified_outlined,
            children: _intersperse([
              _LimitRow(
                label: l10n.officialStatusLabel,
                value: officialStatusLabel,
                isWarning: bank.isLimitedPublic,
              ),
              _LimitRow(
                label: l10n.officialChannelLabel,
                value: panelChannelLabel,
                isWarning: false,
              ),
              if (bank.lastVerifiedAt != null &&
                  bank.lastVerifiedAt!.isNotEmpty)
                _LimitRow(
                  label: l10n.officialLastVerifiedLabel,
                  value: bank.lastVerifiedAt!,
                  isWarning: false,
                ),
            ]),
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: l10n.smsCommandsTitle,
            icon: Icons.sms_outlined,
            children: [
              _CommandTile(
                command: l10n.cmdTransferMain,
                description: l10n.cmdTransferMainDesc,
              ),
              const Divider(height: 1),
              _CommandTile(
                command: l10n.cmdTransferWithCard,
                description: l10n.cmdTransferWithCardDesc,
              ),
              const Divider(height: 1),
              _CommandTile(
                command: l10n.cmdBalance,
                description: l10n.cmdBalanceDesc,
              ),
              const Divider(height: 1),
              _CommandTile(
                command: l10n.cmdBalanceCard,
                description: l10n.cmdBalanceCardDesc,
              ),
              const Divider(height: 1),
              _CommandTile(
                command: l10n.cmdHistory,
                description: l10n.cmdHistoryDesc,
              ),
              const Divider(height: 1),
              _CommandTile(
                command: l10n.cmdBlock,
                description: l10n.cmdBlockDesc,
              ),
              const Divider(height: 1),
              _CommandTile(
                command: l10n.cmdLimit,
                description: l10n.cmdLimitDesc,
              ),
            ],
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: l10n.limitsTitle,
            icon: Icons.shield_outlined,
            children: [
              _LimitRow(
                label: l10n.limitEconomyPerTxLabel,
                value: l10n.limitEconomyPerTxValue,
                isWarning: true,
              ),
              const Divider(height: 1),
              _LimitRow(
                label: l10n.limitEconomyPerDayLabel,
                value: l10n.limitEconomyPerDayValue,
                isWarning: true,
              ),
              const Divider(height: 1),
              _LimitRow(
                label: l10n.limitFullPerTxLabel,
                value: l10n.limitFullPerTxValue,
                isWarning: false,
              ),
              const Divider(height: 1),
              _LimitRow(
                label: l10n.limitFullPerDayLabel,
                value: l10n.limitFullPerDayValue,
                isWarning: false,
              ),
              const Divider(height: 1),
              _LimitRow(
                label: l10n.limitCardToCardLabel,
                value: l10n.limitCardToCardValue,
                isWarning: false,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _InfoBanner(
            icon: Icons.tips_and_updates_outlined,
            color: isDark
                ? colorScheme.surfaceContainerHighest
                : const Color(0xFFE8F5E9),
            iconColor: isDark ? colorScheme.onSurface : AppColors.green,
            textColor: isDark ? colorScheme.onSurface : AppColors.greenDark,
            text: l10n.personalLimitBanner,
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: l10n.notificationFormatsTitle,
            icon: Icons.receipt_long_outlined,
            children: [
              _ExampleTile(
                label: l10n.exampleIncomingLabel,
                example: l10n.exampleIncomingText,
              ),
              const Divider(height: 1),
              _ExampleTile(
                label: l10n.examplePurchaseLabel,
                example: l10n.examplePurchaseText,
              ),
              const Divider(height: 1),
              _ExampleTile(
                label: l10n.exampleTransferLabel,
                example: l10n.exampleTransferText,
              ),
              const Divider(height: 1),
              _ExampleTile(
                label: l10n.exampleCashWithdrawalLabel,
                example: l10n.exampleCashWithdrawalText,
              ),
            ],
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: l10n.importantRulesTitle,
            icon: Icons.rule_outlined,
            children: [
              _RuleItem(
                icon: Icons.check_circle_outline,
                color: AppColors.green,
                text: l10n.ruleRecipientClient,
              ),
              _RuleItem(
                icon: Icons.check_circle_outline,
                color: AppColors.green,
                text: l10n.rulePhoneLinked,
              ),
              _RuleItem(
                icon: Icons.warning_amber,
                color: Colors.orange,
                text: l10n.ruleSmsIrreversible,
              ),
              _RuleItem(
                icon: Icons.warning_amber,
                color: Colors.orange,
                text: l10n.ruleSpecifyLast4,
              ),
              _RuleItem(
                icon: Icons.info_outline,
                color: Colors.blue,
                text: l10n.ruleEconomyVsFull,
              ),
              _RuleItem(
                icon: Icons.info_outline,
                color: Colors.blue,
                text: l10n.ruleResetAtMidnight,
              ),
            ],
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: l10n.feesTitle,
            icon: Icons.percent_outlined,
            children: [
              _LimitRow(
                label: l10n.feeEconomyLabel,
                value: l10n.feeEconomyValue,
                isWarning: true,
              ),
              const Divider(height: 1),
              _LimitRow(
                label: l10n.feeFullLabel,
                value: l10n.feeFullValue,
                isWarning: false,
              ),
              const Divider(height: 1),
              _LimitRow(
                label: l10n.feeSubscriptionLabel,
                value: l10n.feeSubscriptionValue,
                isWarning: false,
              ),
            ],
          ),
          const SizedBox(height: 16),

          _InfoBanner(
            icon: Icons.verified_user_outlined,
            color: colorScheme.surfaceContainerHighest,
            iconColor: colorScheme.onSurface,
            text: l10n.disclaimerText,
          ),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () => _openUrl(context, 'https://www.sberbank.ru'),
            icon: const Icon(Icons.open_in_browser),
            label: Text(l10n.officialSiteButton),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _composeSmsToNumber(context, '900'),
            icon: const Icon(Icons.help_outline),
            label: Text(l10n.helpContact900),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Generic bank ──────────────────────────────────────────────────────────

  Widget _buildGenericBankPage(BuildContext context, BankEntry bank) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    final helpNumber = bank.helpNumber ?? bank.sms.number;
    final officialStatusLabel = _officialStatusLabel(context, bank);
    final panelChannelLabel = _panelChannelLabel(bank.panelChannel);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transferLimitsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoBanner(
            icon: Icons.info_outline,
            color: colorScheme.primaryContainer,
            iconColor: colorScheme.primary,
            text: _genericInfoBanner(context),
          ),
          const SizedBox(height: 16),

          if (bank.isLimitedPublic) ...[
            _InfoBanner(
              icon: Icons.warning_amber,
              color: colorScheme.tertiaryContainer,
              iconColor: colorScheme.onTertiaryContainer,
              text: _limitedWarningText(context),
            ),
            const SizedBox(height: 16),
          ] else if (bank.requiresManualVerification) ...[
            _InfoBanner(
              icon: Icons.error_outline,
              color: colorScheme.errorContainer,
              iconColor: colorScheme.error,
              text: _manualWarningText(context),
            ),
            const SizedBox(height: 16),
          ],

          _SectionCard(
            title: l10n.officialDataTitle,
            icon: Icons.verified_outlined,
            children: _intersperse([
              _LimitRow(
                label: l10n.officialStatusLabel,
                value: officialStatusLabel,
                isWarning:
                    bank.isLimitedPublic || bank.requiresManualVerification,
              ),
              _LimitRow(
                label: l10n.officialChannelLabel,
                value: panelChannelLabel,
                isWarning: !bank.isOperational,
              ),
              if (bank.lastVerifiedAt != null &&
                  bank.lastVerifiedAt!.isNotEmpty)
                _LimitRow(
                  label: l10n.officialLastVerifiedLabel,
                  value: bank.lastVerifiedAt!,
                  isWarning: false,
                ),
            ]),
          ),
          const SizedBox(height: 16),

          // SMS transfer command
          if (bank.canSendSms) ...[
            _SectionCard(
              title: l10n.transferSmsCommandTitle,
              icon: Icons.sms_outlined,
              children: [
                _CommandTile(
                  command: bank.sms.template!,
                  description: l10n.sendToLabel(bank.sms.number ?? ''),
                ),
                if (bank.sms.example != null) ...[
                  const Divider(height: 1),
                  _ExampleTile(
                    label: l10n.exampleLabelShort,
                    example: bank.sms.example!,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],

          // USSD transfer command
          if (bank.canSendUssd) ...[
            _SectionCard(
              title: l10n.transferUssdCommandTitle,
              icon: Icons.dialpad_outlined,
              children: [
                _CommandTile(command: bank.ussd.template!, description: ''),
                if (bank.ussd.example != null) ...[
                  const Divider(height: 1),
                  _ExampleTile(
                    label: l10n.exampleLabelShort,
                    example: bank.ussd.example!,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],

          if (!bank.isOperational) ...[
            _InfoBanner(
              icon: Icons.info_outline,
              color: colorScheme.surfaceContainerHighest,
              iconColor: colorScheme.onSurface,
              text: _commandChannelUnavailableText(context),
            ),
            const SizedBox(height: 16),
          ],

          // Transfer limits
          if (bank.transferLimits.isNotEmpty) ...[
            _SectionCard(
              title: l10n.limitsTitle,
              icon: Icons.shield_outlined,
              children: _intersperse(
                bank.transferLimits
                    .map(
                      (item) => _LimitRow(
                        label: item.label,
                        value: item.value,
                        isWarning: item.isWarning,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            _InfoBanner(
              icon: Icons.shield_outlined,
              color: colorScheme.surfaceContainerHighest,
              iconColor: colorScheme.onSurface,
              text: _genericBankLimitsContactBanner(context),
            ),
            const SizedBox(height: 16),
          ],

          // Transfer fees
          if (bank.transferFees.isNotEmpty) ...[
            _SectionCard(
              title: l10n.feesTitle,
              icon: Icons.percent_outlined,
              children: _intersperse(
                bank.transferFees
                    .map(
                      (item) => _LimitRow(
                        label: item.label,
                        value: item.value,
                        isWarning: item.isWarning,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Notification examples from JSON parser_examples
          if (bank.parserExamples.isNotEmpty) ...[
            _SectionCard(
              title: l10n.notificationExamplesTitle,
              icon: Icons.receipt_long_outlined,
              children: bank.parserExamples
                  .map((ex) => _ExampleTile(label: ex.type, example: ex.text))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Rules: bank-specific if available, otherwise universal
          _SectionCard(
            title: l10n.importantRulesTitle,
            icon: Icons.rule_outlined,
            children: bank.bankRules.isNotEmpty
                ? bank.bankRules
                      .map(
                        (rule) => _RuleItem(
                          icon: Icons.info_outline,
                          color: Colors.blue,
                          text: rule,
                        ),
                      )
                      .toList()
                : [
                    _RuleItem(
                      icon: Icons.check_circle_outline,
                      color: AppColors.green,
                      text: l10n.rulePhoneLinked,
                    ),
                    _RuleItem(
                      icon: Icons.warning_amber,
                      color: Colors.orange,
                      text: l10n.ruleSmsIrreversible,
                    ),
                    _RuleItem(
                      icon: Icons.info_outline,
                      color: Colors.blue,
                      text: l10n.ruleSpecifyLast4,
                    ),
                  ],
          ),
          const SizedBox(height: 16),

          _InfoBanner(
            icon: Icons.verified_user_outlined,
            color: colorScheme.surfaceContainerHighest,
            iconColor: colorScheme.onSurface,
            text: _genericBankDisclaimer(context),
          ),
          const SizedBox(height: 24),

          if (bank.officialWebsite != null) ...[
            OutlinedButton.icon(
              onPressed: () => _openUrl(context, bank.officialWebsite!),
              icon: const Icon(Icons.open_in_browser),
              label: Text(l10n.officialSiteButton),
            ),
            const SizedBox(height: 8),
          ],
          if (helpNumber != null) ...[
            OutlinedButton.icon(
              onPressed: () => _composeSmsToNumber(context, helpNumber),
              icon: const Icon(Icons.help_outline),
              label: Text(l10n.helpContactNumber(helpNumber)),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _officialStatusLabel(BuildContext context, BankEntry bank) {
    return switch (bank.officialStatus) {
      'verified_public' => _localizedText(
        context,
        ru: 'Подтверждено открытыми данными',
        en: 'Confirmed by public data',
      ),
      'limited_public' => _localizedText(
        context,
        ru: 'Подтверждено частично',
        en: 'Partially confirmed',
      ),
      'manual_verification_required' => _localizedText(
        context,
        ru: 'Нужна дополнительная проверка',
        en: 'Needs additional verification',
      ),
      _ => _localizedText(context, ru: 'Не указано', en: 'Not specified'),
    };
  }

  String _panelChannelLabel(String? panelChannel) {
    if (panelChannel == null || panelChannel.trim().isEmpty) {
      return 'Unknown';
    }
    final acronyms = {'sms', 'ussd', 'app', 'web'};
    return panelChannel
        .split('_')
        .map((part) {
          final lower = part.toLowerCase();
          if (acronyms.contains(lower)) {
            return lower.toUpperCase();
          }
          if (lower == 'imps') return 'IMPS';
          return '${part[0].toUpperCase()}${part.substring(1)}';
        })
        .join(' / ');
  }

  String _genericBankLimitsContactBanner(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Лимиты переводов и комиссии могут зависеть от тарифа и типа операции. Уточняйте актуальные условия в официальном канале банка.',
      en: 'Transfer limits and fees may depend on your plan and transfer type. Check the current terms in the official bank channel.',
    );
  }

  String _genericBankDisclaimer(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Это приложение не является официальным банковским продуктом. Команды формируются для удобства, а перевод выполняется стандартным SMS- или USSD-каналом через оператора связи.',
      en: 'This app is not an official banking product. Commands are prepared for convenience, while the transfer itself is performed through the standard SMS or USSD channel of the mobile carrier.',
    );
  }

  String _genericInfoBanner(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Данные собраны из открытых источников. Лимиты, комиссии и условия могут меняться, поэтому перед переводом лучше проверить их в официальном канале банка.',
      en: 'The data is collected from public sources. Limits, fees, and conditions may change, so it is best to verify them in the bank official channel before sending.',
    );
  }

  String _sberInfoBanner(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Данные показаны для текущей версии приложения. Перед отправкой команды проверьте актуальные условия на sberbank.ru или по номеру 900.',
      en: 'The data is shown for the current app version. Before sending a command, verify the latest conditions at sberbank.ru or via 900.',
    );
  }

  String _limitedWarningText(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Для этого канала часть публичных данных подтверждена не полностью. Используйте экран как справку и перепроверяйте условия в банке перед отправкой.',
      en: 'Some public details for this channel are not fully confirmed. Use this screen as a reference and verify the conditions with the bank before sending.',
    );
  }

  String _manualWarningText(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Для этого банка или канала сейчас недостаточно открытых официальных подтверждений. Данные показаны только как ориентир.',
      en: 'There is currently not enough open official confirmation for this bank or channel. The values are shown for guidance only.',
    );
  }

  String _commandChannelUnavailableText(BuildContext context) {
    return _localizedText(
      context,
      ru: 'Прямой SMS- или USSD-канал для этого банка сейчас не подтвержден. Экран показан как справка по доступным публичным данным.',
      en: 'A direct SMS or USSD channel is not currently confirmed for this bank. This screen is shown as a reference based on available public data.',
    );
  }

  String _localizedText(
    BuildContext context, {
    required String ru,
    required String en,
  }) {
    return Localizations.localeOf(context).languageCode == 'ru' ? ru : en;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Inserts [Divider]s between list items.
  List<Widget> _intersperse(List<Widget> items) {
    if (items.isEmpty) return items;
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) result.add(const Divider(height: 1));
    }
    return result;
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final l10n = context.l10n;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.cannotOpenBrowser)));
      }
    }
  }

  Future<void> _composeSmsToNumber(BuildContext context, String number) async {
    final l10n = context.l10n;
    final uri = Uri.parse('sms:$number');
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      await Clipboard.setData(ClipboardData(text: number));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.number900Copied)));
      }
    }
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.text,
    this.textColor,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _CommandTile extends StatelessWidget {
  const _CommandTile({required this.command, required this.description});

  final String command;
  final String description;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: command));
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.copiedCommand(command))));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    command,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(
                  Icons.copy_outlined,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({
    required this.label,
    required this.value,
    required this.isWarning,
  });

  final String label;
  final String value;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final valueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: isWarning ? Colors.orange.shade700 : colorScheme.primary,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final useStackedLayout =
            constraints.maxWidth < 360 ||
            label.length > 28 ||
            value.length > 20;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: useStackedLayout
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text(value, style: valueStyle),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 4,
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: valueStyle,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.label, required this.example});

  final String label;
  final String example;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              example,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
