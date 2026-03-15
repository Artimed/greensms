import '../core/logging/app_logger.dart';
import '../core/services/bank/bank_registry_service.dart';
import '../features/pro_license/presentation/license_controller.dart';
import 'app_controller.dart';
import 'di/pro_service_locator.dart';
import 'di/service_locator.dart';

Future<AppController> bootstrapApplicationPro() async {
  await configureDependencies();
  await configureProDependencies();

  final logger = sl<AppLogger>();
  await sl<BankRegistryService>().load();
  await sl<LicenseController>().initialize();

  final controller = sl<AppController>();
  try {
    await controller.initialize();
  } catch (error, stackTrace) {
    logger.error('Pro bootstrap failed', error: error, stackTrace: stackTrace);
    rethrow;
  }
  return controller;
}
