import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/supabase_config.dart';
import '../domain/entities/license_status.dart';

class LicenseRemoteDataSource {
  LicenseRemoteDataSource(this._client);

  final http.Client _client;

  Future<LicenseActivationResult> activate({
    required String key,
    required String deviceId,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(SupabaseConfig.activateEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'apikey': SupabaseConfig.anonKey,
            },
            body: jsonEncode({'key': key, 'device_id': deviceId}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final expiresAtStr = json['expires_at'] as String?;
        return LicenseActivationSuccess(
          LicenseStatus(
            tier: LicenseTier.pro,
            expiresAt: expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null,
            lastValidatedAt: DateTime.now(),
          ),
        );
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        return LicenseActivationFailure('Invalid or expired license key.');
      }
      return LicenseActivationFailure('Server error (${response.statusCode}). Try again.');
    } on Exception catch (e) {
      return LicenseActivationFailure('Network error: $e');
    }
  }

  Future<LicenseActivationResult> refresh({
    required String key,
    required String deviceId,
  }) => activate(key: key, deviceId: deviceId);
}
