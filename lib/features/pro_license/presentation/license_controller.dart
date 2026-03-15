import 'package:flutter/foundation.dart';

import '../../../core/services/license/installation_id_service.dart';
import '../data/license_local_data_source.dart';
import '../data/license_remote_data_source.dart';
import '../domain/entities/license_status.dart';

class LicenseController extends ChangeNotifier {
  LicenseController({
    required InstallationIdService installationIdService,
    required LicenseLocalDataSource local,
    required LicenseRemoteDataSource remote,
  })  : _installationIdService = installationIdService,
        _local = local,
        _remote = remote;

  final InstallationIdService _installationIdService;
  final LicenseLocalDataSource _local;
  final LicenseRemoteDataSource _remote;

  LicenseStatus _status = const LicenseStatus.free();
  String _installationId = '';
  bool _isLoading = false;
  String? _error;

  LicenseStatus get status => _status;
  String get installationId => _installationId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isProActive => _status.isProActive;

  Future<void> initialize() async {
    _installationId = await _installationIdService.getOrCreate();
    _status = await _local.loadStatus();
    notifyListeners();
    if (_status.needsSilentRefresh) {
      await _silentRefresh();
    }
  }

  Future<void> activate(String key) async {
    if (key.trim().isEmpty) {
      _error = 'Please enter a license key.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remote.activate(key: key.trim(), deviceId: _installationId);

    if (result is LicenseActivationSuccess) {
      _status = result.status;
      await _local.saveStatus(_status);
      await _local.saveKey(key.trim());
    } else if (result is LicenseActivationFailure) {
      _error = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _silentRefresh() async {
    final key = await _local.loadKey();
    if (key == null) return;
    final result = await _remote.refresh(key: key, deviceId: _installationId);
    if (result is LicenseActivationSuccess) {
      _status = result.status;
      await _local.saveStatus(_status);
      notifyListeners();
    }
  }
}
