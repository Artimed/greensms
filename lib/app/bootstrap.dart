import '../core/logging/app_logger.dart';
import '../core/services/bank/bank_registry_service.dart';
import 'app_controller.dart';
import 'di/service_locator.dart';

Future<AppController> bootstrapApplication() async {
  await configureDependencies();
  final logger = sl<AppLogger>();

  // Pre-load bank registry from bundled JSON asset
  await sl<BankRegistryService>().load();

  final controller = sl<AppController>();

  try {
    await controller.initialize();
  } catch (error, stackTrace) {
    logger.error('Bootstrap failed', error: error, stackTrace: stackTrace);
    rethrow;
  }

  return controller;
}
