import 'package:permission_handler/permission_handler.dart';

class PermissionsSnapshot {
  const PermissionsSnapshot({
    required this.smsGranted,
    required this.sendSmsGranted,
    required this.cameraGranted,
  });

  final bool smsGranted;
  final bool sendSmsGranted;
  final bool cameraGranted;
}

abstract interface class PermissionsService {
  Future<PermissionsSnapshot> status();
  Future<bool> requestSms();
  Future<bool> requestSendSms();
  Future<bool> requestCamera();
  Future<bool> openSystemAppSettings();
}

class PermissionHandlerService implements PermissionsService {
  @override
  Future<PermissionsSnapshot> status() async {
    final smsGranted = await Permission.sms.isGranted;
    return PermissionsSnapshot(
      smsGranted: smsGranted,
      sendSmsGranted: smsGranted,
      cameraGranted: await Permission.camera.isGranted,
    );
  }

  @override
  Future<bool> requestSms() async {
    // Permission.sms на Android = READ_SMS (группа SMS).
    // При показе системного диалога Android запрашивает всю группу,
    // поэтому RECEIVE_SMS тоже получает разрешение.
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestSendSms() async {
    // Permission.sms покрывает группу SMS, включая SEND_SMS.
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<bool> openSystemAppSettings() => openAppSettings();
}
