enum LicenseTier { free, pro }

class LicenseStatus {
  const LicenseStatus({
    required this.tier,
    this.expiresAt,
    this.lastValidatedAt,
  });

  const LicenseStatus.free()
      : tier = LicenseTier.free,
        expiresAt = null,
        lastValidatedAt = null;

  final LicenseTier tier;
  final DateTime? expiresAt;
  final DateTime? lastValidatedAt;

  bool get isProActive {
    if (tier != LicenseTier.pro) return false;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!.add(const Duration(days: 7)));
  }

  bool get isExpired =>
      tier == LicenseTier.pro &&
      expiresAt != null &&
      DateTime.now().isAfter(expiresAt!);

  bool get needsSilentRefresh {
    if (lastValidatedAt == null) return tier == LicenseTier.pro;
    return DateTime.now().difference(lastValidatedAt!).inHours >= 24;
  }
}

sealed class LicenseActivationResult {}

class LicenseActivationSuccess extends LicenseActivationResult {
  LicenseActivationSuccess(this.status);
  final LicenseStatus status;
}

class LicenseActivationFailure extends LicenseActivationResult {
  LicenseActivationFailure(this.message);
  final String message;
}
