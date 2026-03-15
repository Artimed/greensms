import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/logging/app_logger.dart';
import '../core/result/result.dart';
import '../core/services/local_data_maintenance_service.dart';
import '../core/services/permissions_service.dart';
import '../features/qr/domain/entities/qr_history_direction.dart';
import '../features/qr/domain/usecases/add_qr_history_use_case.dart';
import '../features/qr/domain/usecases/load_recent_recipients_use_case.dart';
import '../features/qr/domain/usecases/load_today_used_amount_use_case.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/domain/usecases/load_settings_use_case.dart';
import '../features/settings/domain/usecases/mark_onboarding_done_use_case.dart';
import '../features/settings/domain/usecases/update_daily_limit_use_case.dart';
import '../features/settings/domain/usecases/update_direct_sms_configured_use_case.dart';
import '../features/settings/domain/usecases/update_direct_sms_enabled_use_case.dart';
import '../features/settings/domain/usecases/update_device_phone_use_case.dart';
import '../features/settings/domain/usecases/update_locale_code_use_case.dart';
import '../features/settings/domain/usecases/update_selected_bank_id_use_case.dart';
import '../features/settings/domain/usecases/update_selected_country_code_use_case.dart';
import '../features/settings/domain/usecases/update_theme_mode_use_case.dart';
import '../features/sms/domain/entities/account_summary.dart';
import '../features/sms/domain/entities/sms_message.dart';
import '../features/sms/domain/usecases/handle_incoming_sms_use_case.dart';
import '../features/sms/domain/usecases/load_dashboard_use_case.dart';
import '../features/sms/domain/usecases/refresh_sms_use_case.dart';
import '../features/sms/domain/usecases/send_direct_sms_use_case.dart';
import '../features/sms/domain/usecases/watch_incoming_sms_use_case.dart';

class AppController extends ChangeNotifier {
  AppController({
    required LoadSettingsUseCase loadSettings,
    required MarkOnboardingDoneUseCase markOnboardingDone,
    required UpdateDevicePhoneUseCase updateDevicePhone,
    required UpdateDirectSmsEnabledUseCase updateDirectSmsEnabled,
    required UpdateDirectSmsConfiguredUseCase updateDirectSmsConfigured,
    required UpdateSelectedCountryCodeUseCase updateSelectedCountryCode,
    required UpdateSelectedBankIdUseCase updateSelectedBankId,
    required UpdateDailyLimitUseCase updateDailyLimit,
    required UpdateThemeModeUseCase updateThemeMode,
    required UpdateLocaleCodeUseCase updateLocaleCode,
    required PermissionsService permissionsService,
    required RefreshSmsUseCase refreshSms,
    required SendDirectSmsUseCase sendDirectSms,
    required LoadDashboardUseCase loadDashboard,
    required WatchIncomingSmsUseCase watchIncomingSms,
    required HandleIncomingSmsUseCase handleIncomingSms,
    required LoadRecentRecipientsUseCase loadRecentRecipients,
    required AddQrHistoryUseCase addQrHistory,
    required LoadTodayUsedAmountUseCase loadTodayUsedAmount,
    required LocalDataMaintenanceService maintenance,
    required AppLogger logger,
  }) : _loadSettings = loadSettings,
       _markOnboardingDone = markOnboardingDone,
       _updateDevicePhone = updateDevicePhone,
       _updateDirectSmsEnabled = updateDirectSmsEnabled,
       _updateDirectSmsConfigured = updateDirectSmsConfigured,
       _updateSelectedCountryCode = updateSelectedCountryCode,
       _updateSelectedBankId = updateSelectedBankId,
       _updateDailyLimit = updateDailyLimit,
       _updateThemeMode = updateThemeMode,
       _updateLocaleCode = updateLocaleCode,
       _permissionsService = permissionsService,
       _refreshSms = refreshSms,
       _sendDirectSms = sendDirectSms,
       _loadDashboard = loadDashboard,
       _watchIncomingSms = watchIncomingSms,
       _handleIncomingSms = handleIncomingSms,
       _loadRecentRecipients = loadRecentRecipients,
       _addQrHistory = addQrHistory,
       _loadTodayUsedAmount = loadTodayUsedAmount,
       _maintenance = maintenance,
       _logger = logger;

  final LoadSettingsUseCase _loadSettings;
  final MarkOnboardingDoneUseCase _markOnboardingDone;
  final UpdateDevicePhoneUseCase _updateDevicePhone;
  final UpdateDirectSmsEnabledUseCase _updateDirectSmsEnabled;
  final UpdateDirectSmsConfiguredUseCase _updateDirectSmsConfigured;
  final UpdateSelectedCountryCodeUseCase _updateSelectedCountryCode;
  final UpdateSelectedBankIdUseCase _updateSelectedBankId;
  final UpdateDailyLimitUseCase _updateDailyLimit;
  final UpdateThemeModeUseCase _updateThemeMode;
  final UpdateLocaleCodeUseCase _updateLocaleCode;
  final PermissionsService _permissionsService;
  final RefreshSmsUseCase _refreshSms;
  final SendDirectSmsUseCase _sendDirectSms;
  final LoadDashboardUseCase _loadDashboard;
  final WatchIncomingSmsUseCase _watchIncomingSms;
  final HandleIncomingSmsUseCase _handleIncomingSms;
  final LoadRecentRecipientsUseCase _loadRecentRecipients;
  final AddQrHistoryUseCase _addQrHistory;
  final LoadTodayUsedAmountUseCase _loadTodayUsedAmount;
  final LocalDataMaintenanceService _maintenance;
  final AppLogger _logger;

  StreamSubscription<SmsMessage>? _incomingSubscription;

  AppSettings settings = const AppSettings(
    smsLimit: 10,
    pinEnabled: false,
    themeMode: 'system',
    localeCode: 'en',
    onboardingDone: false,
    devicePhone: '',
    directSmsEnabled: false,
    directSmsConfigured: false,
    selectedCountryCode: null,
    selectedBankId: null,
  );
  PermissionsSnapshot permissions = const PermissionsSnapshot(
    smsGranted: false,
    sendSmsGranted: false,
    cameraGranted: false,
  );

  bool initialized = false;
  bool isBusy = false;
  DateTime? lastUpdated;
  String? errorMessage;

  /// Amount of transfers initiated from the app today.
  double todayUsedAmount = 0.0;

  final List<SmsMessage> _messages = <SmsMessage>[];
  final List<AccountSummary> _accounts = <AccountSummary>[];
  List<SmsMessage> get messages => List.unmodifiable(_messages);
  List<AccountSummary> get accounts => List.unmodifiable(_accounts);
  String get activeCountryCode {
    final country = (settings.selectedCountryCode ?? '').trim().toUpperCase();
    return country.isEmpty ? 'RU' : country;
  }

  /// Remaining daily limit. `null` means no limit set.
  double? get dailyLimitRemaining {
    final limit = settings.dailyLimit;
    if (limit == null || limit <= 0) return null;
    final remaining = limit - todayUsedAmount;
    return remaining < 0 ? 0 : remaining;
  }

  /// True when the provided amount exceeds remaining limit.
  bool wouldExceedLimit(double? amount) {
    if (amount == null || amount <= 0) return false;
    final remaining = dailyLimitRemaining;
    if (remaining == null) return false;
    return amount > remaining;
  }

  Future<void> initialize() async {
    if (initialized) return;

    try {
      settings = await _loadSettings.call();
      permissions = await _permissionsService.status();
      await _syncDirectSmsWithPermission(autoEnableIfNeeded: true);
      await _loadAllLocalState();

      _incomingSubscription = _watchIncomingSms.call().listen(
        _onIncomingSms,
        onError: (Object error, StackTrace stackTrace) {
          _logger.error(
            'Incoming SMS stream failed',
            error: error,
            stackTrace: stackTrace,
          );
        },
      );
    } catch (error, stackTrace) {
      errorMessage = 'Application initialization failed.';
      _logger.error(errorMessage!, error: error, stackTrace: stackTrace);
    }

    initialized = true;
    notifyListeners();

    // Auto-refresh on startup when permissions are already granted.
    if (settings.onboardingDone && permissions.smsGranted) {
      Future.microtask(refreshSmsFromDevice);
    }
  }

  Future<void> completeOnboarding() async {
    final smsGranted = await _permissionsService.requestSms();
    final cameraGranted = await _permissionsService.requestCamera();

    permissions = PermissionsSnapshot(
      smsGranted: smsGranted,
      sendSmsGranted: smsGranted,
      cameraGranted: cameraGranted,
    );

    await _markOnboardingDone.call();
    settings = settings.copyWith(onboardingDone: true);

    notifyListeners();

    // Immediately read SMS after onboarding when permission is granted.
    if (smsGranted) {
      Future.microtask(refreshSmsFromDevice);
    }
  }

  Future<void> updateDevicePhone(String phone) async {
    final normalized = phone.trim();
    await _updateDevicePhone.call(normalized);
    settings = settings.copyWith(devicePhone: normalized);
    notifyListeners();
  }

  Future<void> updateDailyLimit(double? limit) async {
    final normalized = (limit == null || limit < 0) ? 0.0 : limit;
    await _updateDailyLimit.call(normalized);
    settings = settings.copyWith(dailyLimit: normalized);
    notifyListeners();
  }

  Future<void> updateThemeMode(String mode) async {
    await _updateThemeMode.call(mode);
    settings = settings.copyWith(themeMode: mode);
    notifyListeners();
  }

  Future<void> updateLocaleCode(String code) async {
    await _updateLocaleCode.call(code);
    settings = settings.copyWith(localeCode: code);
    notifyListeners();
  }

  Future<void> updateSelectedCountryCode(String? countryCode) async {
    final normalized = (countryCode ?? '').trim();
    final next = normalized.isEmpty ? null : normalized.toUpperCase();
    await _updateSelectedCountryCode.call(next);
    settings = settings.copyWith(selectedCountryCode: next);
    notifyListeners();
  }

  Future<void> updateSelectedBankId(String? bankId) async {
    final normalized = (bankId ?? '').trim();
    final next = normalized.isEmpty ? null : normalized;
    await _updateSelectedBankId.call(next);
    settings = settings.copyWith(selectedBankId: next);
    notifyListeners();
  }

  Future<void> applyBankRouting({
    required String? countryCode,
    required String? bankId,
  }) async {
    final nextCountryRaw = (countryCode ?? '').trim().toUpperCase();
    final nextCountry = nextCountryRaw.isEmpty ? null : nextCountryRaw;
    final nextBankRaw = (bankId ?? '').trim();
    final nextBank = nextBankRaw.isEmpty ? null : nextBankRaw;

    final previousCountry = settings.selectedCountryCode;
    final previousBank = settings.selectedBankId;
    final countryChanged = previousCountry != nextCountry;
    final bankChanged = previousBank != nextBank;

    if (!countryChanged && !bankChanged) {
      return;
    }

    if (countryChanged) {
      await _updateSelectedCountryCode.call(nextCountry);
    }
    if (bankChanged) {
      await _updateSelectedBankId.call(nextBank);
    }

    // Reload scoped settings: picks per-bank limit and per-country phone.
    final reloaded = await _loadSettings.call();
    settings = reloaded;

    await _loadDashboardOnly();
    await _refreshTodayUsed();
    lastUpdated = DateTime.now();
    notifyListeners();
  }

  Future<void> requestSmsPermission() async {
    await _permissionsService.requestSms();
    await refreshPermissionsStatus(notify: false);
    notifyListeners();
  }

  Future<void> requestSendSmsPermission() async {
    await _permissionsService.requestSendSms();
    await refreshPermissionsStatus(notify: false);
    notifyListeners();
  }

  Future<void> requestCameraPermission() async {
    await _permissionsService.requestCamera();
    await refreshPermissionsStatus(notify: false);
    notifyListeners();
  }

  Future<bool> setDirectSmsEnabled(bool enabled) async {
    await refreshPermissionsStatus(notify: false);

    if (!enabled) {
      await _updateDirectSmsEnabled.call(false);
      await _updateDirectSmsConfigured.call(true);
      settings = settings.copyWith(
        directSmsEnabled: false,
        directSmsConfigured: true,
      );
      notifyListeners();
      return true;
    }

    if (!permissions.sendSmsGranted) {
      await requestSendSmsPermission();
      if (!permissions.sendSmsGranted) {
        return false;
      }
    }

    await _updateDirectSmsEnabled.call(true);
    await _updateDirectSmsConfigured.call(true);
    settings = settings.copyWith(
      directSmsEnabled: true,
      directSmsConfigured: true,
    );
    notifyListeners();
    return true;
  }

  Future<bool> openSystemAppSettings() {
    return _permissionsService.openSystemAppSettings();
  }

  Future<void> refreshPermissionsStatus({bool notify = true}) async {
    permissions = await _permissionsService.status();
    await _syncDirectSmsWithPermission(autoEnableIfNeeded: true);
    if (notify) {
      notifyListeners();
    }
  }

  Future<bool> sendDirectSms({
    required String address,
    required String body,
  }) async {
    if (!settings.directSmsEnabled) {
      return false;
    }

    if (!permissions.sendSmsGranted) {
      await requestSendSmsPermission();
      if (!permissions.sendSmsGranted) {
        return false;
      }
    }

    final result = await _sendDirectSms.call(address: address, body: body);
    return result.when(
      success: (_) => true,
      failure: (message, error) {
        _logger.error(message, error: error);
        return false;
      },
    );
  }

  Future<void> refreshSmsFromDevice() async {
    if (!permissions.smsGranted) {
      await requestSmsPermission();
      if (!permissions.smsGranted) {
        errorMessage = 'SMS read permission is required.';
        notifyListeners();
        return;
      }
    }

    await _runBusy(() async {
      final countryCode = activeCountryCode;
      final result = await _refreshSms.call(
        limit: settings.smsLimit,
        countryCode: countryCode,
      );
      result.when(
        success: (_) {},
        failure: (message, error) {
          errorMessage = message;
          _logger.error(message, error: error);
        },
      );
      await _loadAllLocalState();
    });
  }

  Future<void> addQrHistory({
    required String phone,
    required String direction,
    double? amount,
    String? note,
    String? profileName,
  }) async {
    await _addQrHistory.call(
      phone: phone,
      direction: direction,
      countryCode: activeCountryCode,
      amount: amount,
      note: note,
      profileName: profileName,
    );
    // Update used-limit counter only after confirmed "sent" transfers.
    if (direction == QrHistoryDirection.sent) {
      await _refreshTodayUsed();
    }
  }

  Future<List<String>> loadRecentRecipients({
    String? countryCode,
    int limit = 5,
  }) =>
      _loadRecentRecipients.call(
        countryCode: countryCode ?? activeCountryCode,
        limit: limit,
      );

  Future<void> clearLocalData() async {
    await _runBusy(() async {
      await _maintenance.clearAll();
      await _loadAllLocalState();
    });
  }

  Future<void> _onIncomingSms(SmsMessage message) async {
    final result = await _handleIncomingSms.call(
      message,
      limit: settings.smsLimit,
      countryCode: activeCountryCode,
    );

    if (result is Failure<void>) {
      errorMessage = result.message;
      notifyListeners();
      return;
    }

    await _loadDashboardOnly();
  }

  Future<void> _loadAllLocalState() async {
    await Future.wait([
      _loadDashboardOnly(),
      _refreshTodayUsed(),
    ]);
    lastUpdated = DateTime.now();
    notifyListeners();
  }

  Future<void> _loadDashboardOnly() async {
    final data = await _loadDashboard.call(
      limit: settings.smsLimit,
      countryCode: activeCountryCode,
    );
    _messages
      ..clear()
      ..addAll(data.messages);
    _accounts
      ..clear()
      ..addAll(data.accounts);
  }

  Future<void> _refreshTodayUsed() async {
    todayUsedAmount = await _loadTodayUsedAmount.call(
      countryCode: activeCountryCode,
    );
  }

  Future<void> _syncDirectSmsWithPermission({
    required bool autoEnableIfNeeded,
  }) async {
    if (!permissions.sendSmsGranted && settings.directSmsEnabled) {
      await _updateDirectSmsEnabled.call(false);
      settings = settings.copyWith(directSmsEnabled: false);
      return;
    }

    if (autoEnableIfNeeded &&
        permissions.sendSmsGranted &&
        !settings.directSmsConfigured) {
      await _updateDirectSmsEnabled.call(true);
      await _updateDirectSmsConfigured.call(true);
      settings = settings.copyWith(
        directSmsEnabled: true,
        directSmsConfigured: true,
      );
    }
  }

  Future<void> _runBusy(Future<void> Function() task) async {
    if (isBusy) return;

    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      await task();
    } catch (error, stackTrace) {
      errorMessage = 'Operation failed.';
      _logger.error(errorMessage!, error: error, stackTrace: stackTrace);
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _incomingSubscription?.cancel();
    super.dispose();
  }
}
