import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_controller.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/services/bank/bank_models.dart';
import '../../../core/services/bank/bank_registry_service.dart';
import '../../../core/services/bank/command_builder_service.dart';
import '../domain/entities/qr_history_direction.dart';
import '../domain/entities/qr_payload.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key, required this.controller});

  final AppController controller;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final BankRegistryService _bankRegistry = sl<BankRegistryService>();
  final CommandBuilderService _commandBuilder = sl<CommandBuilderService>();

  QrPayload? _payload;
  String? _raw;
  String? _scannerError;
  bool _handled = false;

  Future<void> _handleDetect(BarcodeCapture capture) async {
    if (_handled || capture.barcodes.isEmpty) {
      return;
    }

    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null) {
      return;
    }

    final payload = QrPayload.decode(rawValue);
    if (payload == null) {
      setState(() {
        _raw = rawValue;
      });
      return;
    }

    _handled = true;
    await widget.controller.addQrHistory(
      phone: payload.phone,
      amount: payload.amount,
      note: payload.note,
      profileName: payload.profileName,
      direction: QrHistoryDirection.prepared,
    );

    setState(() {
      _payload = payload;
      _raw = rawValue;
      _scannerError = null;
    });
  }

  void _onScannerError(Object error, StackTrace stackTrace) {
    if (!mounted) {
      return;
    }
    setState(() {
      _scannerError = error.toString();
      _handled = false;
    });
  }

  Future<_ResolvedQrRouting?> _resolveRoutingForPayload(
    QrPayload payload,
  ) async {
    final selectedBankId = (widget.controller.settings.selectedBankId ?? '')
        .trim();
    var bank = selectedBankId.isNotEmpty
        ? _bankRegistry.getBankById(selectedBankId)
        : null;

    if (bank == null || !bank.isOperational) {
      final selectedCountryCode =
          (widget.controller.settings.selectedCountryCode ?? '').trim();
      bank = selectedCountryCode.isNotEmpty
          ? _bankRegistry.getPrimaryBankForCountry(selectedCountryCode)
          : null;
    }

    final payloadBankId = (payload.bankId ?? '').trim();
    final canAdoptPayloadBank =
        selectedBankId.isEmpty && payloadBankId.isNotEmpty;
    if ((bank == null || canAdoptPayloadBank) && payloadBankId.isNotEmpty) {
      final payloadBank = _bankRegistry.getBankById(payloadBankId);
      if (payloadBank != null && payloadBank.isOperational) {
        bank = payloadBank;
        if (widget.controller.settings.selectedCountryCode !=
                payloadBank.countryCode ||
            widget.controller.settings.selectedBankId != payloadBank.bankId) {
          await widget.controller.applyBankRouting(
            countryCode: payloadBank.countryCode,
            bankId: payloadBank.bankId,
          );
        }
      }
    }

    if (bank == null || !bank.isOperational) {
      return null;
    }

    final route = _resolveRouteForBank(bank, payload);
    if (route == null) {
      return null;
    }

    return _ResolvedQrRouting(bank: bank, route: route);
  }

  BankTransferRoute? _resolveRouteForBank(BankEntry bank, QrPayload payload) {
    final payloadRouteId = (payload.routeId ?? '').trim();
    if (payloadRouteId.isNotEmpty) {
      final exact = bank.supportedRoutes
          .where((route) => route.id == payloadRouteId)
          .firstOrNull;
      if (exact != null) {
        return exact;
      }
    }

    final expectedRecipientType =
        payload.recipientType == QrRecipientType.account
        ? BankRecipientType.account
        : BankRecipientType.phone;
    return bank.supportedRoutes
        .where((route) => route.recipientType == expectedRecipientType)
        .firstOrNull;
  }

  Future<bool?> _showCommandDialog(
    CommandResult commandResult, {
    required String recipientValue,
    required BankRecipientType recipientType,
    required double amount,
    String? sourceLast4,
  }) {
    final l10n = context.l10n;
    final recipientLine = recipientType == BankRecipientType.phone
        ? l10n.createSmsPhone(recipientValue)
        : l10n.createSmsAccount(recipientValue);

    return switch (commandResult) {
      SmsCommandResult(:final number, :final body) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(l10n.createSmsDialogTitle),
          content: Text(
            [
              l10n.smsTargetLabel(number),
              recipientLine,
              l10n.smsDetailsAmount(amount.toStringAsFixed(0)),
              if ((sourceLast4 ?? '').isNotEmpty)
                l10n.smsDetailsLast4(sourceLast4!),
              l10n.createSmsText(body),
            ].join('\n'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
      UssdCommandResult(:final display) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(l10n.ussdDialogTitle),
          content: Text(
            [
              recipientLine,
              l10n.smsDetailsAmount(amount.toStringAsFixed(0)),
              l10n.createSmsText(display),
            ].join('\n'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.openDialerButton),
            ),
          ],
        ),
      ),
    };
  }

  Future<bool> _executeCommand(CommandResult commandResult) async {
    return switch (commandResult) {
      SmsCommandResult(:final number, :final body) => launchUrl(
        Uri.parse('sms:$number?body=${Uri.encodeComponent(body)}'),
      ),
      UssdCommandResult(:final uri) => launchUrl(Uri.parse(uri)),
    };
  }

  Future<void> _composeSms() async {
    final l10n = context.l10n;
    final payload = _payload;
    if (payload == null) {
      return;
    }
    final resolvedRouting = await _resolveRoutingForPayload(payload);
    if (resolvedRouting == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.bankNotAvailable)));
      return;
    }

    if (payload.amount == null || payload.amount! <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.amountRequiredForTransfer)));
      return;
    }

    final commandResult = _commandBuilder.buildRouteCommand(
      bank: resolvedRouting.bank,
      route: resolvedRouting.route,
      input: TransferCommandInput(
        recipientValue: payload.recipientValue,
        amount: payload.amount!,
        sourceLast4: payload.sourceLast4,
      ),
    );
    if (commandResult == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.bankNotAvailable)));
      return;
    }

    final shouldSend = await _showCommandDialog(
      commandResult,
      recipientValue: payload.recipientValue,
      recipientType: resolvedRouting.route.recipientType,
      amount: payload.amount!,
      sourceLast4: payload.sourceLast4,
    );
    if (shouldSend != true) {
      await widget.controller.addQrHistory(
        phone: payload.recipientValue,
        amount: payload.amount,
        note: payload.note,
        profileName: payload.profileName,
        direction: QrHistoryDirection.cancelled,
      );
      return;
    }

    final launched = await _executeCommand(commandResult);
    await widget.controller.addQrHistory(
      phone: payload.recipientValue,
      amount: payload.amount,
      note: payload.note,
      profileName: payload.profileName,
      direction: launched
          ? QrHistoryDirection.sent
          : QrHistoryDirection.cancelled,
    );

    if (launched || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.qrError('command unavailable'))),
    );
  }

  Future<void> _copyPhone() async {
    final l10n = context.l10n;
    final payload = _payload;
    if (payload == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: payload.recipientValue));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.phoneCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!widget.controller.permissions.cameraGranted) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.cameraPermissionNeeded),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: widget.controller.requestCameraPermission,
            child: Text(l10n.allow),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.qrModeTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MobileScanner(
              onDetect: _handleDetect,
              onDetectError: _onScannerError,
              errorBuilder: (ctx, error) => ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.qrError(error.errorDetails?.message ?? 'unknown'),
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_scannerError != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.qrError(_scannerError!)),
            ),
          ),
        if (_payload != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _payload!.recipientType == QrRecipientType.phone
                        ? l10n.phoneLabel(_payload!.recipientValue)
                        : l10n.createSmsAccount(_payload!.recipientValue),
                  ),
                  if (_payload!.amount != null)
                    Text(
                      l10n.smsDetailsAmount(
                        _payload!.amount!.toStringAsFixed(0),
                      ),
                    ),
                  if ((_payload!.note ?? '').isNotEmpty)
                    Text(l10n.noteLabel(_payload!.note!)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _composeSms,
                          child: Text(l10n.composeSmsButton),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _copyPhone,
                          child: Text(l10n.copyPhoneButton),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (_payload == null && _raw != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.qrNotRecognizedWithRaw(_raw!)),
            ),
          ),
      ],
    );
  }
}

class _ResolvedQrRouting {
  const _ResolvedQrRouting({required this.bank, required this.route});

  final BankEntry bank;
  final BankTransferRoute route;
}
