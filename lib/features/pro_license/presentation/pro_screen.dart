import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/gradient_button.dart';
import '../domain/entities/license_status.dart';
import 'license_controller.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({super.key, required this.controller});
  final LicenseController controller;

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenSMS Pro')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final ctrl = widget.controller;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatusCard(status: ctrl.status),
                const SizedBox(height: 16),
                _DeviceIdCard(installationId: ctrl.installationId),
                if (!ctrl.isProActive) ...[
                  const SizedBox(height: 16),
                  _ActivateCard(
                    keyController: _keyController,
                    isLoading: ctrl.isLoading,
                    error: ctrl.error,
                    onActivate: () => ctrl.activate(_keyController.text),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});
  final LicenseStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPro = status.isProActive;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('License Status',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Chip(
                  label: Text(isPro ? 'Pro Active' : 'Free',
                      style: TextStyle(
                        color: isPro ? Colors.white : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      )),
                  backgroundColor: isPro ? Colors.green.shade600 : colorScheme.surfaceContainerHighest,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (isPro && status.expiresAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Expires: ${_fmt(status.expiresAt!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: status.isExpired
                        ? Colors.orange
                        : colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
            if (!isPro) ...[
              const SizedBox(height: 8),
              Text('Unlock forwarding and OTA parser updates.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}

class _DeviceIdCard extends StatelessWidget {
  const _DeviceIdCard({required this.installationId});
  final String installationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device ID',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Share this ID when purchasing a license.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      installationId.isEmpty ? '...' : installationId,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontFamily: 'monospace', letterSpacing: 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: installationId.isEmpty
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: installationId));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Device ID copied'),
                              duration: Duration(seconds: 2)));
                        },
                  icon: const Icon(Icons.copy_outlined),
                  tooltip: 'Copy',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivateCard extends StatelessWidget {
  const _ActivateCard({
    required this.keyController,
    required this.isLoading,
    required this.error,
    required this.onActivate,
  });

  final TextEditingController keyController;
  final bool isLoading;
  final String? error;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activate License',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                hintText: 'Enter license key',
                errorText: error,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              enabled: !isLoading,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onActivate(),
            ),
            const SizedBox(height: 12),
            GradientButton(
              onPressed: isLoading ? null : onActivate,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.lock_open_outlined),
              label: Text(isLoading ? 'Activating...' : 'Activate'),
              width: double.infinity,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
