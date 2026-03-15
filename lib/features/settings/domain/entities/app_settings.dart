class AppSettings {
  const AppSettings({
    required this.smsLimit,
    required this.pinEnabled,
    required this.themeMode,
    required this.localeCode,
    required this.onboardingDone,
    required this.devicePhone,
    required this.directSmsEnabled,
    required this.directSmsConfigured,
    this.selectedCountryCode,
    this.selectedBankId,
    this.dailyLimit,
  });

  final int smsLimit;
  final bool pinEnabled;
  final String themeMode;
  final String localeCode;
  final bool onboardingDone;
  final String devicePhone;
  final bool directSmsEnabled;
  final bool directSmsConfigured;
  final String? selectedCountryCode;
  final String? selectedBankId;

  /// Дневной лимит переводов для текущего выбранного банка/страны.
  /// 0 или null — лимит не установлен.
  final double? dailyLimit;

  AppSettings copyWith({
    int? smsLimit,
    bool? pinEnabled,
    String? themeMode,
    String? localeCode,
    bool? onboardingDone,
    String? devicePhone,
    bool? directSmsEnabled,
    bool? directSmsConfigured,
    Object? selectedCountryCode = _sentinel,
    Object? selectedBankId = _sentinel,
    Object? dailyLimit = _sentinel,
  }) {
    return AppSettings(
      smsLimit: smsLimit ?? this.smsLimit,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      devicePhone: devicePhone ?? this.devicePhone,
      directSmsEnabled: directSmsEnabled ?? this.directSmsEnabled,
      directSmsConfigured: directSmsConfigured ?? this.directSmsConfigured,
      selectedCountryCode: selectedCountryCode == _sentinel
          ? this.selectedCountryCode
          : selectedCountryCode as String?,
      selectedBankId: selectedBankId == _sentinel
          ? this.selectedBankId
          : selectedBankId as String?,
      dailyLimit: dailyLimit == _sentinel
          ? this.dailyLimit
          : dailyLimit as double?,
    );
  }

  factory AppSettings.fromDbMap(Map<String, Object?> map) {
    return AppSettings(
      smsLimit: (map['sms_limit'] as int?) ?? 10,
      pinEnabled: ((map['pin_enabled'] as int?) ?? 0) == 1,
      themeMode: (map['theme_mode'] as String?) ?? 'system',
      localeCode: (map['locale_code'] as String?) ?? 'en',
      onboardingDone: ((map['onboarding_done'] as int?) ?? 0) == 1,
      devicePhone: (map['device_phone'] as String?) ?? '',
      directSmsEnabled: ((map['direct_sms_enabled'] as int?) ?? 0) == 1,
      directSmsConfigured: ((map['direct_sms_configured'] as int?) ?? 0) == 1,
      selectedCountryCode: _nullIfEmpty(
        map['selected_country_code'] as String?,
      ),
      selectedBankId: _nullIfEmpty(map['selected_bank_id'] as String?),
      dailyLimit: (map['daily_limit'] as num?)?.toDouble(),
    );
  }
}

// Sentinel для различия null и «не передан» в copyWith
const Object _sentinel = Object();

String? _nullIfEmpty(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
