import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../app/app_controller.dart';
import '../../pro_license/presentation/license_controller.dart';
import '../../pro_license/presentation/pro_screen.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/services/bank/bank_models.dart';
import '../../../core/services/bank/bank_registry_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../sms/presentation/transfer_limits_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.controller,
    required this.bankRegistry,
  });

  final AppController controller;
  final BankRegistryService bankRegistry;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  static const List<_LanguageOption> _languageOptions = [
    _LanguageOption(code: 'en', nativeName: 'English', flag: '🇬🇧'),
    _LanguageOption(code: 'ru', nativeName: 'Русский', flag: '🇷🇺'),
    _LanguageOption(code: 'hi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    _LanguageOption(code: 'kk', nativeName: 'Қазақша', flag: '🇰🇿'),
    _LanguageOption(code: 'uz', nativeName: "O'zbekcha", flag: '🇺🇿'),
    _LanguageOption(code: 'fil', nativeName: 'Filipino', flag: '🇵🇭'),
    _LanguageOption(code: 'id', nativeName: 'Bahasa Indonesia', flag: '🇮🇩'),
    _LanguageOption(code: 'vi', nativeName: 'Tiếng Việt', flag: '🇻🇳'),
    _LanguageOption(code: 'hy', nativeName: 'Հայերեն', flag: '🇦🇲'),
    _LanguageOption(code: 'ur', nativeName: 'اردو', flag: '🇵🇰'),
    _LanguageOption(code: 'bn', nativeName: 'বাংলা', flag: '🇧🇩'),
  ];

  late final TextEditingController _phoneController;
  late final TextEditingController _limitController;
  late String _activePhonePrefix;
  late String _pendingLocaleCode;
  late String? _selectedCountryCode;
  late String? _selectedBankId;
  late final List<CountryEntry> _countries;
  List<BankEntry> _banksInCountry = <BankEntry>[];

  // Whether the saved bank routes by account (not phone).
  bool get _isAccountMode {
    final bankId = widget.controller.settings.selectedBankId;
    if (bankId == null) return false;
    final bank = widget.bankRegistry.getBankById(bankId);
    return bank?.supportedRoutes.firstOrNull?.recipientType ==
        BankRecipientType.account;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeBankRoutingState();
    _activePhonePrefix = _dialPrefixForCountry(_selectedCountryCode);

    final savedPhone = widget.controller.settings.devicePhone;
    final initialPhone = _isAccountMode
        ? savedPhone
        : (savedPhone.isEmpty ? _activePhonePrefix : savedPhone);
    _phoneController = TextEditingController.fromValue(
      TextEditingValue(
        text: initialPhone,
        selection: TextSelection.collapsed(offset: initialPhone.length),
      ),
    );
    if (!_isAccountMode) {
      _phoneController.addListener(_enforcePhonePrefix);
      _enforcePhonePrefix();
    }

    final limit = widget.controller.settings.dailyLimit;
    _limitController = TextEditingController(
      text: limit != null ? limit.toStringAsFixed(0) : '',
    );
    Future.microtask(_refreshPermissionsState);

    final persistedLocaleCode = widget.controller.settings.localeCode;
    _pendingLocaleCode =
        _languageOptions.any((option) => option.code == persistedLocaleCode)
        ? persistedLocaleCode
        : (persistedLocaleCode == 'tl' ? 'fil' : 'en');
  }

  void _initializeBankRoutingState() {
    _countries = widget.bankRegistry.getCountries()
      ..sort((a, b) => a.countryName.compareTo(b.countryName));

    final selectedCountryFromSettings =
        widget.controller.settings.selectedCountryCode;
    final selectedBankFromSettings = widget.controller.settings.selectedBankId;

    String? fallbackCountry;
    if (_countries.isNotEmpty) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final localeTag =
          '${deviceLocale.languageCode}-${deviceLocale.countryCode ?? ''}';
      final localeBank =
          widget.bankRegistry.getPrimaryBankForLocale(localeTag) ??
          widget.bankRegistry.getPrimaryBankForLocale(
            deviceLocale.languageCode,
          );
      fallbackCountry = localeBank?.countryCode ?? _countries.first.countryCode;
    }

    final selectedStillAvailable = _countries.any(
      (country) => country.countryCode == selectedCountryFromSettings,
    );
    _selectedCountryCode = selectedStillAvailable
        ? selectedCountryFromSettings
        : fallbackCountry;
    _selectedBankId = selectedBankFromSettings;
    _refreshBanksInCountry(autoSelectSingleBank: _selectedBankId == null);
  }

  void _refreshBanksInCountry({bool autoSelectSingleBank = false}) {
    final countryCode = _selectedCountryCode;
    if (countryCode == null) {
      _banksInCountry = <BankEntry>[];
      _selectedBankId = null;
      return;
    }

    _banksInCountry =
        widget.bankRegistry.getOperationalBanksForCountry(countryCode)
          ..sort((a, b) {
            final aPrimary = a.priority == 'primary' ? 0 : 1;
            final bPrimary = b.priority == 'primary' ? 0 : 1;
            final primaryCmp = aPrimary.compareTo(bPrimary);
            if (primaryCmp != 0) return primaryCmp;

            return a.bankName.compareTo(b.bankName);
          });

    final selectedStillAvailable = _banksInCountry.any(
      (bank) => bank.bankId == _selectedBankId,
    );
    if (!selectedStillAvailable) {
      _selectedBankId = autoSelectSingleBank && _banksInCountry.length == 1
          ? _banksInCountry.first.bankId
          : null;
    }
  }

  static const Map<String, String> _countryDialCodes = {
    'RU': '+7',
    'NG': '+234',
    'IN': '+91',
    'PK': '+92',
    'BD': '+880',
    'ID': '+62',
    'PH': '+63',
    'VN': '+84',
    'GH': '+233',
    'AM': '+374',
  };

  static const Map<String, int> _countryNationalPhoneDigits = {
    'RU': 10,
    'NG': 10,
    'IN': 10,
    'PK': 10,
    'BD': 10,
    'ID': 12,
    'PH': 10,
    'VN': 10,
    'GH': 9,
    'AM': 8,
  };

  String _dialPrefixForCountry(String? countryCode) {
    return _countryDialCodes[countryCode] ?? '+7';
  }

  int _maxNationalDigitsForCountry(String? countryCode) {
    return _countryNationalPhoneDigits[countryCode] ?? 12;
  }

  int _maxAccountDigitsForCountry(String? countryCode) {
    return switch (countryCode) {
      'NG' => 10, // NUBAN
      'IN' => 18,
      _ => 20,
    };
  }

  int get _maxPhoneLength {
    return _activePhonePrefix.length +
        _maxNationalDigitsForCountry(_selectedCountryCode);
  }

  void _enforcePhonePrefix() {
    final prefix = _activePhonePrefix;
    final text = _phoneController.text;
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    final prefixDigits = prefix.replaceAll('+', '');
    var clean = digits;
    if (clean.startsWith(prefixDigits)) {
      clean = clean.substring(prefixDigits.length);
    }
    // RU special case: users often type 8XXXXXXXXXX instead of +7.
    if ((_selectedCountryCode ?? 'RU') == 'RU' && clean.startsWith('8')) {
      clean = clean.substring(1);
    }
    final maxDigits = _maxNationalDigitsForCountry(_selectedCountryCode);
    if (clean.length > maxDigits) {
      clean = clean.substring(0, maxDigits);
    }

    final newText = '$prefix$clean';
    if (newText != text) {
      _phoneController.removeListener(_enforcePhonePrefix);
      _phoneController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      _phoneController.addListener(_enforcePhonePrefix);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _phoneController.removeListener(_enforcePhonePrefix);
    _phoneController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermissionsState();
    }
  }

  Future<void> _refreshPermissionsState() async {
    await widget.controller.refreshPermissionsStatus(notify: false);
    if (mounted) {
      setState(() {});
    }
  }

  bool get _bankRoutingDirty {
    return _selectedCountryCode !=
            widget.controller.settings.selectedCountryCode ||
        _selectedBankId != widget.controller.settings.selectedBankId;
  }

  bool get _languageDirty =>
      _pendingLocaleCode != widget.controller.settings.localeCode;

  void _onCountryChanged(String? countryCode) {
    if (countryCode == null) return;
    setState(() {
      _selectedCountryCode = countryCode;
      _refreshBanksInCountry(autoSelectSingleBank: true);
      _phoneController.removeListener(_enforcePhonePrefix);
      if (_isAccountMode) {
        _phoneController.clear();
      } else {
        _activePhonePrefix = _dialPrefixForCountry(countryCode);
        _phoneController.text = _activePhonePrefix;
        _phoneController.selection = TextSelection.collapsed(
          offset: _activePhonePrefix.length,
        );
        _phoneController.addListener(_enforcePhonePrefix);
        _enforcePhonePrefix();
      }
    });
  }

  void _onBankChanged(String? bankId) {
    setState(() {
      _selectedBankId = bankId;
    });
  }

  void _openLimitsInfo(BuildContext context) {
    final bankId = _selectedBankId ?? widget.controller.settings.selectedBankId;
    final bank = bankId != null ? widget.bankRegistry.getBankById(bankId) : null;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TransferLimitsPage(bank: bank),
      ),
    );
  }

  Future<void> _saveBankRouting() async {
    await widget.controller.applyBankRouting(
      countryCode: _selectedCountryCode,
      bankId: _selectedBankId,
    );

    // Reload limit for new scope.
    final reloadedLimit = widget.controller.settings.dailyLimit ?? 0;
    _limitController.text = reloadedLimit.toStringAsFixed(0);
    _limitController.selection = TextSelection.collapsed(
      offset: _limitController.text.length,
    );

    // Reload phone/account for new country scope.
    _activePhonePrefix = _dialPrefixForCountry(_selectedCountryCode);
    final reloadedIdentifier = widget.controller.settings.devicePhone;
    _phoneController.removeListener(_enforcePhonePrefix);
    if (_isAccountMode) {
      _phoneController.text = reloadedIdentifier;
    } else {
      _phoneController.text = reloadedIdentifier.isEmpty
          ? _activePhonePrefix
          : reloadedIdentifier;
      _phoneController.addListener(_enforcePhonePrefix);
      _enforcePhonePrefix();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveLanguage() async {
    await widget.controller.updateLocaleCode(_pendingLocaleCode);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveDailyLimit() async {
    final l10n = context.l10n;
    final raw = _limitController.text.trim().replaceAll(',', '.');
    final value = raw.isEmpty ? null : double.tryParse(raw);
    await widget.controller.updateDailyLimit(value);
    final savedValue = widget.controller.settings.dailyLimit ?? 0;
    _limitController.text = savedValue.toStringAsFixed(0);
    _limitController.selection = TextSelection.collapsed(
      offset: _limitController.text.length,
    );
    final symbol = _selectedCurrencySymbol;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value == null
              ? l10n.snackLimitRemoved
              : '${l10n.limitLabel}: ${value.toStringAsFixed(0)} $symbol',
        ),
      ),
    );
  }

  Future<void> _savePhone() async {
    final l10n = context.l10n;
    final text = _phoneController.text.trim();
    final value = _isAccountMode
        ? text
        : (text == _activePhonePrefix ? '' : text);
    await widget.controller.updateDevicePhone(value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAccountMode ? l10n.snackAccountSaved : l10n.snackPhoneSaved,
        ),
      ),
    );
  }

  Future<void> _clearData() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.clearDataDialogTitle),
        content: Text(l10n.clearDataDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              minimumSize: const Size(0, AppTheme.actionButtonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppTheme.actionButtonRadius,
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await widget.controller.clearLocalData();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.snackDataCleared)));
  }

  Future<void> _toggleDirectSms(bool enabled) async {
    final l10n = context.l10n;
    final applied = await widget.controller.setDirectSmsEnabled(enabled);
    if (!mounted) return;

    if (applied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled ? l10n.directSmsEnabledSnack : l10n.directSmsDisabledSnack,
          ),
        ),
      );
      setState(() {});
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.directSmsPermissionRequired),
        action: SnackBarAction(
          label: l10n.openSettingsButton,
          onPressed: () {
            widget.controller.openSystemAppSettings();
          },
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _toggleReadSms(bool enabled) async {
    final l10n = context.l10n;
    if (enabled) {
      await widget.controller.requestSmsPermission();
      if (mounted) {
        setState(() {});
      }
      return;
    }

    await widget.controller.openSystemAppSettings();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.permissionsManageInSystem)));
  }

  String get _selectedCurrencyCode {
    final selectedBankId = _selectedBankId;
    if (selectedBankId != null && selectedBankId.isNotEmpty) {
      final bank = widget.bankRegistry.getBankById(selectedBankId);
      if (bank != null) return bank.currency;
    }
    final selectedCountryCode = _selectedCountryCode;
    if (selectedCountryCode != null && selectedCountryCode.isNotEmpty) {
      final country = widget.bankRegistry.getCountryByCode(selectedCountryCode);
      if (country != null) return country.currency;
    }
    return 'RUB';
  }

  String get _selectedCurrencySymbol =>
      Formatters.currencySymbolFor(_selectedCurrencyCode);

  String _countryDisplayLabel(CountryEntry country) {
    return '${country.countryName} (${country.countryCode})';
  }

  String _bankDisplayLabel(BankEntry bank) {
    return bank.bankName;
  }

  Widget _buildProCard(BuildContext context) {
    final sl = GetIt.instance;
    if (!sl.isRegistered<LicenseController>()) return const SizedBox.shrink();
    final licenseController = sl<LicenseController>();
    return ListenableBuilder(
      listenable: licenseController,
      builder: (context, _) {
        final isPro = licenseController.isProActive;
        return Card(
          child: ListTile(
            leading: Icon(
              isPro ? Icons.verified_outlined : Icons.workspace_premium_outlined,
              color: isPro ? Colors.green.shade600 : null,
            ),
            title: Text(isPro ? 'GreenSMS Pro' : 'Upgrade to Pro'),
            subtitle: Text(isPro ? 'Active' : 'Forwarding · OTA Parser'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ProScreen(controller: licenseController),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIdentifierCard(
    BuildContext context,
    OutlineInputBorder fieldBorder,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final hasSavedBank = widget.controller.settings.selectedBankId != null;
    final accountMode = _isAccountMode;
    final savedCountry = widget.controller.settings.selectedCountryCode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  accountMode
                      ? Icons.credit_card_outlined
                      : Icons.phone,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  accountMode ? l10n.yourAccountTitle : l10n.devicePhoneTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              accountMode ? l10n.yourAccountDesc : l10n.devicePhoneDesc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (!hasSavedBank) ...[
              const SizedBox(height: 8),
              Text(
                l10n.selectBankFirstHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (accountMode)
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                maxLength: _maxAccountDigitsForCountry(savedCountry),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: fieldBorder,
                  labelText: l10n.accountNumberLabel,
                  prefixIcon: const Icon(Icons.credit_card_outlined),
                  counterText: '',
                ),
              )
            else
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: _maxPhoneLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  border: fieldBorder,
                  labelText: l10n.phoneNumberLabel,
                  hintText: '$_activePhonePrefix...',
                  prefixIcon: const Icon(Icons.dialpad),
                  counterText: '',
                ),
              ),
            const SizedBox(height: 12),
            GradientButton(onPressed: _savePhone, label: Text(l10n.save)),
          ],
        ),
      ),
    );
  }

  Widget _buildBankSelector(
    BuildContext context,
    OutlineInputBorder fieldBorder,
    AppLocalizations l10n,
  ) {
    if (_banksInCountry.isEmpty) {
      return InputDecorator(
        decoration: InputDecoration(
          border: fieldBorder,
          labelText: l10n.bankLabel,
          helperText: l10n.bankNotAvailable,
          helperMaxLines: 3,
        ),
        child: Text(
          l10n.bankNotAvailable,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    if (_banksInCountry.length == 1) {
      final bank = _banksInCountry.first;
      return InputDecorator(
        decoration: InputDecoration(
          border: fieldBorder,
          labelText: l10n.bankLabel,
          helperText: l10n.bankAutoSelectedHint,
          helperMaxLines: 3,
        ),
        child: Text(_bankDisplayLabel(bank)),
      );
    }

    return DropdownButtonFormField<String>(
      key: ValueKey<String?>(_selectedBankId),
      initialValue: _selectedBankId,
      borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
      items: _banksInCountry
          .map(
            (bank) => DropdownMenuItem<String>(
              value: bank.bankId,
              child: Text(_bankDisplayLabel(bank)),
            ),
          )
          .toList(),
      onChanged: _onBankChanged,
      decoration: InputDecoration(
        border: fieldBorder,
        labelText: l10n.bankLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
    );
    final compactOutlinedStyle = OutlinedButton.styleFrom(
      minimumSize: const Size(0, AppTheme.actionButtonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
      ),
    );
    final clearTonalStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, AppTheme.actionButtonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProCard(context),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.bankRoutingTitle,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
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
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.bankRoutingDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  key: ValueKey<String?>(_selectedCountryCode),
                  initialValue: _selectedCountryCode,
                  borderRadius: BorderRadius.circular(
                    AppTheme.actionButtonRadius,
                  ),
                  items: _countries
                      .map(
                        (country) => DropdownMenuItem<String>(
                          value: country.countryCode,
                          child: Text(_countryDisplayLabel(country)),
                        ),
                      )
                      .toList(),
                  onChanged: _onCountryChanged,
                  decoration: InputDecoration(
                    border: fieldBorder,
                    labelText: l10n.countryLabel,
                  ),
                ),
                const SizedBox(height: 10),
                _buildBankSelector(context, fieldBorder, l10n),
                const SizedBox(height: 12),
                GradientButton(
                  onPressed: _bankRoutingDirty ? _saveBankRouting : null,
                  label: Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        _buildIdentifierCard(context, fieldBorder, l10n, colorScheme),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.dailyTransferLimit,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dailyLimitDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _limitController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    border: fieldBorder,
                    labelText: l10n.limitLabel,
                    hintText: l10n.limitHint,
                    prefixIcon: const Icon(Icons.payments_outlined),
                    suffixText: _selectedCurrencySymbol,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    GradientButton(
                      onPressed: _saveDailyLimit,
                      label: Text(l10n.save),
                    ),
                    const SizedBox(width: 8),
                    if ((widget.controller.settings.dailyLimit ?? 0) > 0)
                      OutlinedButton(
                        style: compactOutlinedStyle,
                        onPressed: () {
                          _limitController.clear();
                          _saveDailyLimit();
                        },
                        child: Text(l10n.removeLimitButton),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.languageTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _pendingLocaleCode,
                  borderRadius: BorderRadius.circular(
                    AppTheme.actionButtonRadius,
                  ),
                  items: _languageOptions
                      .map(
                        (option) => DropdownMenuItem(
                          value: option.code,
                          child: Text('${option.flag} ${option.nativeName}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _pendingLocaleCode = value;
                      });
                    }
                  },
                  decoration: InputDecoration(border: fieldBorder),
                ),
                const SizedBox(height: 12),
                GradientButton(
                  onPressed: _languageDirty ? _saveLanguage : null,
                  label: Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.themeTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  selected: {widget.controller.settings.themeMode},
                  onSelectionChanged: (v) =>
                      widget.controller.updateThemeMode(v.first),
                  segments: const [
                    ButtonSegment(
                      value: 'light',
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: 'system',
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Icon(Icons.security, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.permissionsTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                value: widget.controller.permissions.smsGranted,
                title: Text(l10n.readSmsTitle),
                subtitle: Text(l10n.readSmsDesc),
                onChanged: _toggleReadSms,
              ),
              SwitchListTile(
                value: widget.controller.settings.directSmsEnabled,
                title: Text(l10n.directSmsTitle),
                subtitle: Text(l10n.directSmsDesc),
                onChanged: _toggleDirectSms,
              ),
              SwitchListTile(
                value: widget.controller.permissions.cameraGranted,
                title: Text(l10n.cameraTitle),
                subtitle: Text(l10n.cameraDesc),
                onChanged: (_) =>
                    widget.controller.requestCameraPermission().then((_) {
                      if (mounted) setState(() {});
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: Icon(Icons.delete_outline, color: colorScheme.error),
            title: Text(l10n.clearLocalDataTitle),
            subtitle: Text(l10n.clearLocalDataDesc),
            trailing: FilledButton.tonal(
              style: clearTonalStyle,
              onPressed: _clearData,
              child: Text(l10n.clear),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.primary),
            title: Text(l10n.aboutTitle),
            subtitle: Text(l10n.aboutVersion),
          ),
        ),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_outline, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Support GreenSMS',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _DonateRow(label: 'Ko-fi', value: 'ko-fi.com/greensms'),
                const _DonateRow(label: 'ETH', value: '0x2008FD9D984caf5d19F0536bBD6C8aFf3aE6F91c'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DonateRow extends StatelessWidget {
  const _DonateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.nativeName,
    required this.flag,
  });

  final String code;
  final String nativeName;
  final String flag;
}
