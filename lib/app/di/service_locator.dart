import 'package:get_it/get_it.dart';

import '../../core/database/app_database.dart';
import '../../core/logging/app_logger.dart';
import '../../core/services/bank/bank_registry_service.dart';
import '../../core/services/bank/command_builder_service.dart';
import '../../core/services/local_data_maintenance_service.dart';
import '../../core/services/permissions_service.dart';
import '../../features/qr/data/datasources/qr_local_data_source.dart';
import '../../features/qr/data/repositories/qr_repository_impl.dart';
import '../../features/qr/domain/repositories/qr_repository.dart';
import '../../features/qr/domain/usecases/add_qr_history_use_case.dart';
import '../../features/qr/domain/usecases/load_recent_recipients_use_case.dart';
import '../../features/qr/domain/usecases/load_today_used_amount_use_case.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/load_settings_use_case.dart';
import '../../features/settings/domain/usecases/mark_onboarding_done_use_case.dart';
import '../../features/settings/domain/usecases/update_daily_limit_use_case.dart';
import '../../features/settings/domain/usecases/update_direct_sms_configured_use_case.dart';
import '../../features/settings/domain/usecases/update_direct_sms_enabled_use_case.dart';
import '../../features/settings/domain/usecases/update_device_phone_use_case.dart';
import '../../features/settings/domain/usecases/update_locale_code_use_case.dart';
import '../../features/settings/domain/usecases/update_selected_bank_id_use_case.dart';
import '../../features/settings/domain/usecases/update_selected_country_code_use_case.dart';
import '../../features/settings/domain/usecases/update_theme_mode_use_case.dart';
import '../../features/sms/data/datasources/sms_local_data_source.dart';
import '../../features/sms/data/datasources/sms_native_data_source.dart';
import '../../features/sms/data/parsing/sms_parser.dart';
import '../../features/sms/data/repositories/sms_repository_impl.dart';
import '../../features/sms/domain/repositories/sms_repository.dart';
import '../../features/sms/domain/usecases/handle_incoming_sms_use_case.dart';
import '../../features/sms/domain/usecases/load_dashboard_use_case.dart';
import '../../features/sms/domain/usecases/refresh_sms_use_case.dart';
import '../../features/sms/domain/usecases/send_direct_sms_use_case.dart';
import '../../features/sms/domain/usecases/watch_incoming_sms_use_case.dart';
import '../app_controller.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AppController>()) {
    return;
  }

  sl.registerLazySingleton<AppLogger>(AppLogger.new);
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase.instance);
  sl.registerLazySingleton<PermissionsService>(PermissionHandlerService.new);
  sl.registerLazySingleton<BankRegistryService>(BankRegistryService.new);
  sl.registerLazySingleton<CommandBuilderService>(CommandBuilderService.new);
  sl.registerLazySingleton<LocalDataMaintenanceService>(
    () => LocalDataMaintenanceService(sl()),
  );

  sl.registerLazySingleton<SmsParser>(SmsParser.new);
  sl.registerLazySingleton<SmsNativeDataSource>(SmsNativeDataSource.new);
  sl.registerLazySingleton<SmsLocalDataSource>(() => SmsLocalDataSource(sl()));
  sl.registerLazySingleton<SmsRepository>(
    () => SmsRepositoryImpl(native: sl(), local: sl()),
  );

  sl.registerLazySingleton<QrLocalDataSource>(() => QrLocalDataSource(sl()));
  sl.registerLazySingleton<QrRepository>(() => QrRepositoryImpl(sl()));

  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<LoadSettingsUseCase>(
    () => LoadSettingsUseCase(sl()),
  );
  sl.registerLazySingleton<MarkOnboardingDoneUseCase>(
    () => MarkOnboardingDoneUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateDevicePhoneUseCase>(
    () => UpdateDevicePhoneUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateDirectSmsEnabledUseCase>(
    () => UpdateDirectSmsEnabledUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateDirectSmsConfiguredUseCase>(
    () => UpdateDirectSmsConfiguredUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateDailyLimitUseCase>(
    () => UpdateDailyLimitUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateSelectedCountryCodeUseCase>(
    () => UpdateSelectedCountryCodeUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateSelectedBankIdUseCase>(
    () => UpdateSelectedBankIdUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateThemeModeUseCase>(
    () => UpdateThemeModeUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateLocaleCodeUseCase>(
    () => UpdateLocaleCodeUseCase(sl()),
  );

  sl.registerLazySingleton<RefreshSmsUseCase>(
    () => RefreshSmsUseCase(repository: sl(), parser: sl()),
  );
  sl.registerLazySingleton<SendDirectSmsUseCase>(
    () => SendDirectSmsUseCase(sl()),
  );
  sl.registerLazySingleton<WatchIncomingSmsUseCase>(
    () => WatchIncomingSmsUseCase(repository: sl(), parser: sl()),
  );
  sl.registerLazySingleton<HandleIncomingSmsUseCase>(
    () => HandleIncomingSmsUseCase(sl()),
  );
  sl.registerLazySingleton<LoadDashboardUseCase>(
    () => LoadDashboardUseCase(sl()),
  );

  sl.registerLazySingleton<LoadRecentRecipientsUseCase>(
    () => LoadRecentRecipientsUseCase(sl()),
  );
  sl.registerLazySingleton<AddQrHistoryUseCase>(
    () => AddQrHistoryUseCase(sl()),
  );
  sl.registerLazySingleton<LoadTodayUsedAmountUseCase>(
    () => LoadTodayUsedAmountUseCase(sl()),
  );

  sl.registerFactory<AppController>(
    () => AppController(
      loadSettings: sl(),
      markOnboardingDone: sl(),
      updateDevicePhone: sl(),
      updateDirectSmsEnabled: sl(),
      updateDirectSmsConfigured: sl(),
      updateSelectedCountryCode: sl(),
      updateSelectedBankId: sl(),
      updateDailyLimit: sl(),
      updateThemeMode: sl(),
      updateLocaleCode: sl(),
      permissionsService: sl(),
      refreshSms: sl(),
      sendDirectSms: sl(),
      loadDashboard: sl(),
      watchIncomingSms: sl(),
      handleIncomingSms: sl(),
      loadRecentRecipients: sl(),
      addQrHistory: sl(),
      loadTodayUsedAmount: sl(),
      maintenance: sl(),
      logger: sl(),
    ),
  );
}
