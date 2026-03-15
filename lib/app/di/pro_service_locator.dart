import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/services/license/installation_id_service.dart';
import '../../features/pro_license/data/license_local_data_source.dart';
import '../../features/pro_license/data/license_remote_data_source.dart';
import '../../features/pro_license/presentation/license_controller.dart';
import 'service_locator.dart';

Future<void> configureProDependencies() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => storage);
  sl.registerLazySingleton<http.Client>(http.Client.new);
  sl.registerLazySingleton<InstallationIdService>(() => InstallationIdService(sl()));
  sl.registerLazySingleton<LicenseLocalDataSource>(() => LicenseLocalDataSource(sl()));
  sl.registerLazySingleton<LicenseRemoteDataSource>(() => LicenseRemoteDataSource(sl()));
  sl.registerLazySingleton<LicenseController>(
    () => LicenseController(
      installationIdService: sl(),
      local: sl(),
      remote: sl(),
    ),
  );
}
