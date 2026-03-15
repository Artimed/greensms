import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/entities/license_status.dart';

class LicenseLocalDataSource {
  LicenseLocalDataSource(this._storage);

  final FlutterSecureStorage _storage;

  static const _keyIsPro = 'license_is_pro';
  static const _keyExpiresAt = 'license_expires_at';
  static const _keyLastValidated = 'license_last_validated_at';
  static const _keyLicenseKey = 'license_key';

  Future<LicenseStatus> loadStatus() async {
    final isPro = await _storage.read(key: _keyIsPro) == 'true';
    if (!isPro) return const LicenseStatus.free();
    final expiresAtStr = await _storage.read(key: _keyExpiresAt);
    final lastValidatedStr = await _storage.read(key: _keyLastValidated);
    return LicenseStatus(
      tier: LicenseTier.pro,
      expiresAt: expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null,
      lastValidatedAt: lastValidatedStr != null ? DateTime.tryParse(lastValidatedStr) : null,
    );
  }

  Future<void> saveStatus(LicenseStatus status) async {
    await _storage.write(
      key: _keyIsPro,
      value: status.tier == LicenseTier.pro ? 'true' : 'false',
    );
    if (status.expiresAt != null) {
      await _storage.write(key: _keyExpiresAt, value: status.expiresAt!.toIso8601String());
    }
    await _storage.write(key: _keyLastValidated, value: DateTime.now().toIso8601String());
  }

  Future<String?> loadKey() => _storage.read(key: _keyLicenseKey);

  Future<void> saveKey(String key) => _storage.write(key: _keyLicenseKey, value: key);

  Future<void> clearAll() async {
    await _storage.delete(key: _keyIsPro);
    await _storage.delete(key: _keyExpiresAt);
    await _storage.delete(key: _keyLastValidated);
    await _storage.delete(key: _keyLicenseKey);
  }
}
