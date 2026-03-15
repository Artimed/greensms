import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_controller.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/services/bank/bank_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/bank/bank_registry_service.dart';
import '../../../core/services/bank/command_builder_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../domain/entities/qr_history_direction.dart';
import '../domain/entities/qr_payload.dart';

class QrHubPage extends StatefulWidget {
  const QrHubPage({
    super.key,
    required this.controller,
    required this.bankRegistry,
    required this.commandBuilder,
  });

  final AppController controller;
  final BankRegistryService bankRegistry;
  final CommandBuilderService commandBuilder;

  @override
  State<QrHubPage> createState() => _QrHubPageState();
}

class _QrHubPageState extends State<QrHubPage> with WidgetsBindingObserver {
  final ImagePicker _imagePicker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _processing = false;
  bool _pausedByLifecycle = false;
  String? _hint;

  /// Resolved once per page instance from the device locale.
  BankEntry? _currentBank;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resolveBank();
  }

  void _resolveBank() {
    final selectedCountryCode = widget.controller.settings.selectedCountryCode;

    final selectedBankId = widget.controller.settings.selectedBankId;
    if (selectedBankId != null && selectedBankId.isNotEmpty) {
      final selectedBank = widget.bankRegistry.getBankById(selectedBankId);
      if (selectedBank != null && selectedBank.isOperational) {
        _currentBank = selectedBank;
        return;
      }
    }

    if (selectedCountryCode != null && selectedCountryCode.isNotEmpty) {
      final selectedCountryBank = widget.bankRegistry.getPrimaryBankForCountry(
        selectedCountryCode,
      );
      _currentBank = selectedCountryBank;
      return;
    }

    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final localeTag =
        '${deviceLocale.languageCode}-${deviceLocale.countryCode ?? ''}';
    _currentBank =
        widget.bankRegistry.getPrimaryBankForLocale(localeTag) ??
        widget.bankRegistry.getPrimaryBankForLocale(deviceLocale.languageCode);
  }

  Future<_ResolvedQrRouting?> _resolveRoutingForPayload(
    QrPayload payload,
  ) async {
    _resolveBank();

    var bank = _currentBank;
    final selectedBankId = (widget.controller.settings.selectedBankId ?? '')
        .trim();
    final payloadBankId = (payload.bankId ?? '').trim();

    final canAdoptPayloadBank =
        selectedBankId.isEmpty && payloadBankId.isNotEmpty;
    if ((bank == null || canAdoptPayloadBank) && payloadBankId.isNotEmpty) {
      final payloadBank = widget.bankRegistry.getBankById(payloadBankId);
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
        _currentBank = payloadBank;
      }
    }

    if (bank == null) {
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_pausedByLifecycle && !_processing) {
          _pausedByLifecycle = false;
          unawaited(_startScannerIfPossible());
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _pausedByLifecycle = true;
        unawaited(_stopScannerIfRunning());
        break;
    }
  }

  Future<void> _startScannerIfPossible({bool reportError = false}) async {
    if (!mounted) {
      return;
    }
    if (!widget.controller.permissions.cameraGranted) {
      return;
    }

    final state = _scannerController.value;
    if (state.isRunning || state.isStarting) {
      return;
    }

    try {
      await _scannerController.start();
    } catch (error) {
      if (reportError && mounted) {
        final l10n = context.l10n;
        setState(() {
          _hint = l10n.qrError(error.toString());
        });
      }
    }
  }

  Future<void> _stopScannerIfRunning() async {
    final state = _scannerController.value;
    if (!state.isRunning) {
      return;
    }
    try {
      await _scannerController.stop();
    } catch (_) {
      // Ignore transient platform camera errors and keep UI responsive.
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing || capture.barcodes.isEmpty) {
      return;
    }

    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) {
      return;
    }

    try {
      await _processRaw(rawValue);
    } catch (error) {
      if (!mounted) {
        return;
      }
      final l10n = context.l10n;
      setState(() {
        _hint = l10n.qrError(error.toString());
      });
      _processing = false;
      await _startScannerIfPossible();
    }
  }

  void _onScannerError(Object error, StackTrace stackTrace) {
    if (!mounted) {
      return;
    }
    final l10n = context.l10n;
    setState(() {
      _processing = false;
      _hint = l10n.qrError(error.toString());
    });
  }

  Future<void> _processRaw(String rawValue) async {
    final l10n = context.l10n;
    final payload = QrPayload.decode(rawValue);
    if (payload == null) {
      setState(() {
        _hint = l10n.qrNotRecognized;
      });
      return;
    }

    await _processPayload(payload, enrichAmount: true);
  }

  Future<void> _processPayload(
    QrPayload payload, {
    required bool enrichAmount,
  }) async {
    final l10n = context.l10n;
    final resolvedRouting = await _resolveRoutingForPayload(payload);
    if (resolvedRouting == null) {
      setState(() {
        _hint = l10n.bankNotAvailable;
      });
      return;
    }
    final bank = resolvedRouting.bank;
    var route = resolvedRouting.route;

    // If the QR carries no specific routeId and the bank supports multiple
    // channels for this recipient type, let the user pick SMS or USSD.
    if ((payload.routeId ?? '').isEmpty) {
      final qrRecipientType = payload.recipientType == QrRecipientType.account
          ? BankRecipientType.account
          : BankRecipientType.phone;
      final matchingRoutes = bank.supportedRoutes
          .where((r) => r.recipientType == qrRecipientType)
          .toList();
      if (matchingRoutes.length > 1) {
        final picked = await _showChannelPickerDialog(matchingRoutes);
        if (picked == null) {
          if (mounted) setState(() => _hint = l10n.scanningContinues);
          return;
        }
        route = picked;
      }
    }

    final effectivePayload = enrichAmount
        ? await _ensurePayloadWithAmount(payload, bank, route)
        : payload;
    if (effectivePayload == null) return;

    final commandResult = widget.commandBuilder.buildRouteCommand(
      bank: bank,
      route: route,
      input: TransferCommandInput(
        recipientValue: effectivePayload.recipientValue,
        amount: effectivePayload.amount ?? 0,
        sourceLast4: effectivePayload.sourceLast4,
      ),
    );
    if (commandResult == null) {
      if (mounted) {
        setState(() {
          _hint =
              effectivePayload.amount != null && effectivePayload.amount! > 0
              ? l10n.bankNotAvailable
              : l10n.amountRequiredForTransfer;
        });
      }
      return;
    }

    await _runPreparedTransfer(
      commandResult: commandResult,
      recipientValue: effectivePayload.recipientValue,
      recipientType: effectivePayload.recipientType == QrRecipientType.account
          ? BankRecipientType.account
          : BankRecipientType.phone,
      amount: effectivePayload.amount!,
      sourceLast4: effectivePayload.sourceLast4,
      note: effectivePayload.note,
      profileName: effectivePayload.profileName,
    );
  }

  Future<void> _startDirectPhoneTransfer() async {
    if (_processing) return;
    final l10n = context.l10n;

    final transferData = await _showDirectTransferSheet();
    if (transferData == null) return;

    if (transferData.countryCode !=
            widget.controller.settings.selectedCountryCode ||
        transferData.bank.bankId != widget.controller.settings.selectedBankId) {
      await widget.controller.applyBankRouting(
        countryCode: transferData.countryCode,
        bankId: transferData.bank.bankId,
      );
      _resolveBank();
    }

    final commandResult = widget.commandBuilder.buildRouteCommand(
      bank: transferData.bank,
      route: transferData.route,
      input: TransferCommandInput(
        recipientValue: transferData.recipientValue,
        amount: transferData.amount,
        sourceLast4: transferData.sourceLast4,
      ),
    );
    if (commandResult == null) {
      if (mounted) {
        setState(() {
          _hint = l10n.bankNotAvailable;
        });
      }
      return;
    }

    await _runPreparedTransfer(
      commandResult: commandResult,
      recipientValue: transferData.recipientValue,
      recipientType: transferData.route.recipientType,
      amount: transferData.amount,
      sourceLast4: transferData.sourceLast4,
    );
  }

  Future<QrPayload?> _ensurePayloadWithAmount(
    QrPayload payload,
    BankEntry bank,
    BankTransferRoute route,
  ) async {
    final transferData = await _showTransferInputSheet(
      recipientValue: payload.recipientValue,
      recipientType: route.recipientType,
      actionLabel: context.l10n.confirm,
      amountRequired: true,
      initialAmount: payload.amount,
      initialLast4: payload.sourceLast4,
      includeSourceLast4: route.requiresSourceLast4,
      currencySymbol: _currencySymbolFor(bank.currency),
    );
    if (transferData == null) {
      return null;
    }
    return payload.copyWith(
      recipientValue: transferData.recipientValue,
      recipientType: transferData.recipientType == BankRecipientType.account
          ? QrRecipientType.account
          : QrRecipientType.phone,
      amount: transferData.amount,
      sourceLast4: transferData.sourceLast4,
      bankId: bank.bankId,
      routeId: route.id,
    );
  }

  Future<bool?> _showCommandDialog(
    CommandResult commandResult, {
    required String recipientValue,
    required BankRecipientType recipientType,
    double? amount,
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
              if (amount != null)
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
            GradientButton(
              onPressed: () => Navigator.of(context).pop(true),
              height: 40,
              label: Text(l10n.confirm),
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
              if (amount != null)
                l10n.smsDetailsAmount(amount.toStringAsFixed(0)),
              l10n.createSmsText(display),
            ].join('\n'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            GradientButton(
              onPressed: () => Navigator.of(context).pop(true),
              height: 40,
              label: Text(l10n.openDialerButton),
            ),
          ],
        ),
      ),
    };
  }

  Future<void> _runPreparedTransfer({
    required CommandResult commandResult,
    required String recipientValue,
    required BankRecipientType recipientType,
    required double amount,
    String? sourceLast4,
    String? note,
    String? profileName,
  }) async {
    final l10n = context.l10n;
    _processing = true;
    await _stopScannerIfRunning();

    if (widget.controller.wouldExceedLimit(amount)) {
      final remaining = widget.controller.dailyLimitRemaining ?? 0;
      final proceed = await _showLimitWarningDialog(
        amount: amount,
        remaining: remaining,
      );
      if (proceed != true) {
        _processing = false;
        await _startScannerIfPossible();
        if (mounted) {
          setState(() {
            _hint = l10n.transferCancelledLimit;
          });
        }
        return;
      }
    }

    final shouldSend = await _showCommandDialog(
      commandResult,
      recipientValue: recipientValue,
      recipientType: recipientType,
      amount: amount,
      sourceLast4: sourceLast4,
    );
    var isSent = false;
    if (shouldSend == true) {
      await widget.controller.addQrHistory(
        phone: recipientValue,
        amount: amount,
        note: note,
        profileName: profileName,
        direction: QrHistoryDirection.prepared,
      );

      final launched = await _executeCommand(commandResult);
      if (launched && mounted) {
        isSent = (await _showSentConfirmationDialog()) == true;
      }

      await widget.controller.addQrHistory(
        phone: recipientValue,
        amount: amount,
        note: note,
        profileName: profileName,
        direction: isSent
            ? QrHistoryDirection.sent
            : QrHistoryDirection.cancelled,
      );
    }

    if (!mounted) {
      return;
    }

    _processing = false;
    await _startScannerIfPossible();
    setState(() {
      _hint = shouldSend == true && isSent
          ? l10n.smsSentSuccess
          : l10n.scanningContinues;
    });
  }

  Future<bool> _executeCommand(CommandResult commandResult) async {
    return switch (commandResult) {
      SmsCommandResult(:final number, :final body) => _executeSmsCommand(
        number: number,
        body: body,
      ),
      UssdCommandResult(:final uri) => _executeUssdCommand(uri: uri),
    };
  }

  Future<bool> _executeSmsCommand({
    required String number,
    required String body,
  }) async {
    final l10n = context.l10n;

    if (widget.controller.settings.directSmsEnabled) {
      final sentDirect = await widget.controller.sendDirectSms(
        address: number,
        body: body,
      );
      if (sentDirect) return true;
    }

    final uri = Uri.parse('sms:$number?body=${Uri.encodeComponent(body)}');
    final launched = await launchUrl(uri);
    if (!launched && mounted) {
      setState(() {
        _hint = l10n.qrError('sms app unavailable');
      });
    }
    return launched;
  }

  Future<bool> _executeUssdCommand({required String uri}) async {
    final l10n = context.l10n;
    final launched = await launchUrl(Uri.parse(uri));
    if (!launched && mounted) {
      setState(() {
        _hint = l10n.qrError('dialer unavailable');
      });
    }
    return launched;
  }

  Future<void> _pickFromGallery() async {
    final l10n = context.l10n;
    final wasRunning = _scannerController.value.isRunning;
    if (wasRunning) {
      await _stopScannerIfRunning();
    }
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      if (wasRunning) {
        await _startScannerIfPossible();
      }
      return;
    }

    BarcodeCapture? capture;
    try {
      capture = await _scannerController.analyzeImage(image.path);
    } catch (error) {
      if (mounted) {
        setState(() {
          _hint = l10n.qrError(error.toString());
        });
      }
      if (wasRunning) {
        await _startScannerIfPossible();
      }
      return;
    }
    if (capture == null || capture.barcodes.isEmpty) {
      setState(() {
        _hint = l10n.noQrInImage;
      });
      if (wasRunning) {
        await _startScannerIfPossible();
      }
      return;
    }

    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) {
      setState(() {
        _hint = l10n.qrFoundNoData;
      });
      if (wasRunning) {
        await _startScannerIfPossible();
      }
      return;
    }

    await _processRaw(rawValue);

    if (wasRunning && !_processing) {
      await _startScannerIfPossible();
    }
  }

  Future<void> _showGeneratedQr({required bool includeAmount}) async {
    final l10n = context.l10n;
    final wasRunning = _scannerController.value.isRunning;
    if (wasRunning) {
      await _stopScannerIfRunning();
    }

    _resolveBank();
    final bank = _currentBank;
    if (bank == null || bank.supportedRoutes.isEmpty) {
      setState(() {
        _hint = l10n.bankNotAvailable;
      });
      if (wasRunning && !_processing) {
        await _startScannerIfPossible();
      }
      return;
    }

    final preferredRoute = bank.supportedRoutes.first;
    // "My QR" shows OUR own identifier — taken from settings (phone or account).
    final deviceIdentifier = widget.controller.settings.devicePhone.trim();
    if (deviceIdentifier.isEmpty) {
      setState(() {
        _hint = preferredRoute.recipientType == BankRecipientType.account
            ? l10n.setAccountFirst
            : l10n.setPhoneFirst;
      });
      if (wasRunning && !_processing) {
        await _startScannerIfPossible();
      }
      return;
    }

    // When includeAmount=true, ask only for the amount (never for our identifier).
    _TransferInputData? transferData;
    if (includeAmount) {
      transferData = await _showTransferInputSheet(
        recipientValue: deviceIdentifier,
        recipientType: preferredRoute.recipientType,
        actionLabel: l10n.showQrButton,
        amountRequired: false,
        includeSourceLast4: false,
        currencySymbol: _currencySymbolFor(bank.currency),
        allowRecipientEdit: false,
      );
      if (transferData == null) {
        if (wasRunning && !_processing) {
          await _startScannerIfPossible();
        }
        return;
      }
    }

    final payload = QrPayload(
      recipientValue: deviceIdentifier,
      recipientType: preferredRoute.recipientType == BankRecipientType.account
          ? QrRecipientType.account
          : QrRecipientType.phone,
      amount: transferData?.amount,
      sourceLast4: transferData?.sourceLast4,
      bankId: bank.bankId,
      routeId: preferredRoute.id,
    );
    final encoded = payload.encode();

    await widget.controller.addQrHistory(
      phone: payload.recipientValue,
      amount: payload.amount,
      direction: QrHistoryDirection.generated,
    );

    if (!mounted) {
      return;
    }

    if (!mounted) {
      if (wasRunning && !_processing) {
        await _startScannerIfPossible();
      }
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.viewPaddingOf(ctx).bottom;

        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.greenDark.withValues(alpha: 0.92),
                  AppColors.green.withValues(alpha: 0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        payload.recipientType == QrRecipientType.phone
                            ? l10n.phoneQrTitle
                            : l10n.accountQrTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payload.recipientType == QrRecipientType.phone
                            ? l10n.phoneLabel(payload.recipientValue)
                            : l10n.createSmsAccount(payload.recipientValue),
                        textAlign: TextAlign.center,
                        style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (payload.amount != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.smsDetailsAmount(
                            payload.amount!.toStringAsFixed(0),
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if ((payload.sourceLast4 ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.smsDetailsLast4(payload.sourceLast4!),
                          textAlign: TextAlign.center,
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      var qrSize = (constraints.maxWidth - 32).clamp(
                        180.0,
                        320.0,
                      );
                      final maxByHeight = constraints.maxHeight - 24;
                      if (maxByHeight < qrSize) {
                        qrSize = maxByHeight.clamp(180.0, 320.0);
                      }

                      return Center(
                        child: _BrandedQr(data: encoded, size: qrSize),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    payload.recipientType == QrRecipientType.account
                        ? l10n.qrHintAccountOnly
                        : (payload.amount == null
                              ? l10n.qrHintPhoneOnly
                              : l10n.qrHint),
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (wasRunning && !_processing) {
      await _startScannerIfPossible();
    }
  }

  Future<_TransferInputData?> _showTransferInputSheet({
    required String recipientValue,
    required BankRecipientType recipientType,
    required String actionLabel,
    bool amountRequired = true,
    bool includeSourceLast4 = true,
    double? initialAmount,
    String? initialLast4,
    String currencySymbol = '¤',
    bool allowRecipientEdit = false,
  }) async {
    final l10n = context.l10n;
    final availableLast4 = includeSourceLast4
        ? (widget.controller.accounts
              .map((account) => account.last4)
              .where((last4) => RegExp(r'^\d{4}$').hasMatch(last4))
              .toSet()
              .toList()
            ..sort())
        : <String>[];
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
    );

    final amountController = TextEditingController(
      text: initialAmount != null && initialAmount > 0
          ? initialAmount.toStringAsFixed(0)
          : '',
    );
    final recipientController = TextEditingController(text: recipientValue);
    final last4Controller = TextEditingController(
      text: includeSourceLast4 ? (initialLast4 ?? '') : '',
    );
    String? recipientError;
    String? amountError;
    String? last4Error;
    var sourceSectionExpanded =
        includeSourceLast4 && (initialLast4 ?? '').isNotEmpty;

    final result = await showModalBottomSheet<_TransferInputData>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset =
            MediaQuery.viewInsetsOf(ctx).bottom +
            MediaQuery.viewPaddingOf(ctx).bottom;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                color: Theme.of(ctx).colorScheme.surface,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (allowRecipientEdit) ...[
                    Text(
                      l10n.phoneTransferInputTitle,
                      style: Theme.of(ctx).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: recipientController,
                      keyboardType: recipientType == BankRecipientType.phone
                          ? TextInputType.phone
                          : TextInputType.text,
                      maxLength: recipientType == BankRecipientType.phone
                          ? 16
                          : 34,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: recipientType == BankRecipientType.phone
                          ? <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+]'),
                              ),
                            ]
                          : <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9A-Za-z -]'),
                              ),
                            ],
                      decoration: InputDecoration(
                        border: fieldBorder,
                        labelText: recipientType == BankRecipientType.phone
                            ? l10n.recipientPhone
                            : l10n.recipientAccount,
                        errorText: recipientError,
                        counterText: '',
                      ),
                    ),
                  ] else
                    Text(
                      recipientType == BankRecipientType.phone
                          ? l10n.phoneLabel(recipientValue)
                          : l10n.createSmsAccount(recipientValue),
                      style: Theme.of(ctx).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: fieldBorder,
                      labelText: amountRequired
                          ? l10n.amountRequiredLabel
                          : l10n.amountOptional,
                      errorText: amountError,
                      suffixText: currencySymbol,
                    ),
                  ),
                  if (includeSourceLast4) ...[
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            ctx,
                          ).dividerColor.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(
                          ctx,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: sourceSectionExpanded,
                          onExpansionChanged: (expanded) {
                            sourceSectionExpanded = expanded;
                          },
                          title: Text(l10n.sourceAccountOptionalSection),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            12,
                            0,
                            12,
                            12,
                          ),
                          children: [
                            TextField(
                              controller: last4Controller,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: fieldBorder,
                                labelText: l10n.sourceLast4Optional,
                                hintText: l10n.sourceLast4Hint,
                                counterText: '',
                                errorText: last4Error,
                              ),
                            ),
                            if (availableLast4.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: availableLast4.map((last4) {
                                    final selected =
                                        last4Controller.text.trim() == last4;
                                    return ChoiceChip(
                                      label: Text('••$last4'),
                                      selected: selected,
                                      onSelected: (_) {
                                        setSheetState(() {
                                          last4Controller.text = selected
                                              ? ''
                                              : last4;
                                          last4Error = null;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GradientButton(
                          onPressed: () {
                            final rawRecipient = recipientController.text
                                .trim();
                            final normalizedRecipient =
                                recipientType == BankRecipientType.phone
                                ? _normalizePhoneInput(rawRecipient)
                                : _normalizeAccountInput(rawRecipient);
                            final amountRaw = amountController.text.trim();
                            final amount = double.tryParse(amountRaw);
                            final sourceLast4 = last4Controller.text.trim();

                            setSheetState(() {
                              recipientError =
                                  recipientType == BankRecipientType.phone
                                  ? (_phoneDigitsOnly(
                                              normalizedRecipient,
                                            ).length <
                                            10
                                        ? l10n.enterPhoneError
                                        : null)
                                  : (normalizedRecipient.length < 6
                                        ? l10n.enterAccountError
                                        : null);
                              amountError =
                                  amountRequired &&
                                      (amount == null || amount <= 0)
                                  ? l10n.enterAmountError
                                  : null;
                              last4Error =
                                  includeSourceLast4 &&
                                      sourceLast4.isNotEmpty &&
                                      !RegExp(r'^\d{4}$').hasMatch(sourceLast4)
                                  ? l10n.invalidLast4Error
                                  : null;
                            });

                            if (recipientError != null ||
                                amountError != null ||
                                last4Error != null) {
                              return;
                            }

                            Navigator.of(ctx).pop(
                              _TransferInputData(
                                recipientValue: allowRecipientEdit
                                    ? normalizedRecipient
                                    : recipientValue,
                                recipientType: recipientType,
                                amount: amount ?? 0,
                                sourceLast4:
                                    !includeSourceLast4 || sourceLast4.isEmpty
                                    ? null
                                    : sourceLast4,
                              ),
                            );
                          },
                          label: Text(actionLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Do not dispose immediately here: the bottom-sheet route can still
    // rebuild during reverse animation after pop(), which may still access
    // these controllers and crash in debug with "used after being disposed".
    return result;
  }

  Future<_DirectTransferInputData?> _showDirectTransferSheet() async {
    final l10n = context.l10n;
    final countries = widget.bankRegistry.getCountries()
      ..sort((a, b) => a.countryName.compareTo(b.countryName));
    if (countries.isEmpty) {
      if (mounted) {
        setState(() {
          _hint = l10n.bankNotAvailable;
        });
      }
      return null;
    }

    final selectedCountrySetting =
        (widget.controller.settings.selectedCountryCode ?? '')
            .trim()
            .toUpperCase();
    var selectedCountryCode =
        countries.any(
          (country) => country.countryCode == selectedCountrySetting,
        )
        ? selectedCountrySetting
        : (_currentBank?.countryCode ?? countries.first.countryCode);

    List<BankEntry> banksForCountry(String countryCode) {
      final items =
          widget.bankRegistry.getOperationalBanksForCountry(countryCode)
            ..sort((a, b) {
              final primaryCmp = (a.priority == 'primary' ? 0 : 1).compareTo(
                b.priority == 'primary' ? 0 : 1,
              );
              if (primaryCmp != 0) return primaryCmp;
              return a.bankName.compareTo(b.bankName);
            });
      return items;
    }

    var banks = banksForCountry(selectedCountryCode);
    if (banks.isEmpty) {
      selectedCountryCode = countries.first.countryCode;
      banks = banksForCountry(selectedCountryCode);
    }
    if (banks.isEmpty) {
      if (mounted) {
        setState(() {
          _hint = l10n.bankNotAvailable;
        });
      }
      return null;
    }

    var selectedBankId =
        banks.any(
          (bank) => bank.bankId == widget.controller.settings.selectedBankId,
        )
        ? widget.controller.settings.selectedBankId!
        : (_currentBank?.bankId ?? banks.first.bankId);
    var selectedBank = banks.firstWhere(
      (bank) => bank.bankId == selectedBankId,
      orElse: () => banks.first,
    );
    var routes = selectedBank.supportedRoutes;
    var selectedRouteId = routes.first.id;
    var selectedRoute = routes.first;

    final recentRecipients = await widget.controller.loadRecentRecipients();

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
    );

    var recentForCountry = recentRecipients;

    final amountController = TextEditingController();
    final recipientController = TextEditingController();
    final last4Controller = TextEditingController();
    String? recipientError;
    String? amountError;
    String? last4Error;
    var sourceSectionExpanded = false;

    String routeLabel(BankTransferRoute route) {
      return switch ((route.channel, route.recipientType)) {
        (BankTransferChannel.sms, BankRecipientType.phone) =>
          l10n.routeSmsPhone,
        (BankTransferChannel.sms, BankRecipientType.account) =>
          l10n.routeSmsAccount,
        (BankTransferChannel.ussd, BankRecipientType.phone) =>
          l10n.routeUssdPhone,
        (BankTransferChannel.ussd, BankRecipientType.account) =>
          l10n.routeUssdAccount,
      };
    }

    if (!mounted) return null;
    var sheetOpen = true;
    final result = await showModalBottomSheet<_DirectTransferInputData>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset =
            MediaQuery.viewInsetsOf(ctx).bottom +
            MediaQuery.viewPaddingOf(ctx).bottom;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final currencySymbol = _currencySymbolFor(selectedBank.currency);
            final recipientLabel =
                selectedRoute.recipientType == BankRecipientType.phone
                ? l10n.recipientPhone
                : l10n.recipientAccount;
            final recipientKeyboardType =
                selectedRoute.recipientType == BankRecipientType.phone
                ? TextInputType.phone
                : TextInputType.text;
            final recipientFormatters =
                selectedRoute.recipientType == BankRecipientType.phone
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  ]
                : <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z -]')),
                  ];

            return Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                color: Theme.of(ctx).colorScheme.surface,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.phoneTransferInputTitle,
                    style: Theme.of(ctx).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (widget.controller.dailyLimitRemaining != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.limitLabel}: ${widget.controller.dailyLimitRemaining!.toStringAsFixed(0)} ${_currencySymbolFor(selectedBank.currency)}',
                      style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: widget.controller.dailyLimitRemaining! < 1000
                            ? Colors.orange
                            : Theme.of(
                                ctx,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCountryCode,
                    borderRadius: BorderRadius.circular(
                      AppTheme.actionButtonRadius,
                    ),
                    items: countries
                        .map(
                          (country) => DropdownMenuItem<String>(
                            value: country.countryCode,
                            child: Text(
                              '${country.countryName} (${country.countryCode})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setSheetState(() {
                        selectedCountryCode = value;
                        banks = banksForCountry(value);
                        selectedBank = banks.first;
                        selectedBankId = selectedBank.bankId;
                        routes = selectedBank.supportedRoutes;
                        selectedRoute = routes.first;
                        selectedRouteId = selectedRoute.id;
                        recipientController.clear();
                        last4Controller.clear();
                        recipientError = null;
                        last4Error = null;
                        recentForCountry = [];
                      });
                      widget.controller
                          .loadRecentRecipients(countryCode: value)
                          .then((recipients) {
                            if (!sheetOpen) {
                              return;
                            }
                            setSheetState(() {
                              recentForCountry = recipients;
                            });
                          });
                    },
                    decoration: InputDecoration(
                      border: fieldBorder,
                      labelText: l10n.countryLabel,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedBankId,
                    borderRadius: BorderRadius.circular(
                      AppTheme.actionButtonRadius,
                    ),
                    items: banks
                        .map(
                          (bank) => DropdownMenuItem<String>(
                            value: bank.bankId,
                            child: Text(bank.bankName),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setSheetState(() {
                        selectedBank = banks.firstWhere(
                          (bank) => bank.bankId == value,
                        );
                        selectedBankId = value;
                        routes = selectedBank.supportedRoutes;
                        selectedRoute = routes.first;
                        selectedRouteId = selectedRoute.id;
                        recipientController.clear();
                        last4Controller.clear();
                        recipientError = null;
                        last4Error = null;
                      });
                    },
                    decoration: InputDecoration(
                      border: fieldBorder,
                      labelText: l10n.bankLabel,
                    ),
                  ),
                  if (routes.length > 1) ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRouteId,
                      borderRadius: BorderRadius.circular(
                        AppTheme.actionButtonRadius,
                      ),
                      items: routes
                          .map(
                            (route) => DropdownMenuItem<String>(
                              value: route.id,
                              child: Text(routeLabel(route)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setSheetState(() {
                          selectedRoute = routes.firstWhere(
                            (route) => route.id == value,
                          );
                          selectedRouteId = value;
                          recipientController.clear();
                          recipientError = null;
                          if (!selectedRoute.requiresSourceLast4) {
                            last4Controller.clear();
                            last4Error = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        border: fieldBorder,
                        labelText: l10n.routeLabel,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: recipientController,
                    keyboardType: recipientKeyboardType,
                    maxLength:
                        selectedRoute.recipientType == BankRecipientType.phone
                        ? 16
                        : 34,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    inputFormatters: recipientFormatters,
                    decoration: InputDecoration(
                      border: fieldBorder,
                      labelText: recipientLabel,
                      errorText: recipientError,
                      counterText: '',
                    ),
                  ),
                  if (recentForCountry.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: recentForCountry
                            .map(
                              (r) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ActionChip(
                                  label: Text(
                                    r,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    setSheetState(() {
                                      recipientController.text = r;
                                      recipientError = null;
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: fieldBorder,
                      labelText: l10n.amountRequiredLabel,
                      errorText: amountError,
                      suffixText: currencySymbol,
                    ),
                  ),
                  if (selectedRoute.requiresSourceLast4) ...[
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            ctx,
                          ).dividerColor.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(
                          ctx,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: sourceSectionExpanded,
                          onExpansionChanged: (expanded) {
                            sourceSectionExpanded = expanded;
                          },
                          title: Text(l10n.sourceAccountOptionalSection),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            12,
                            0,
                            12,
                            12,
                          ),
                          children: [
                            TextField(
                              controller: last4Controller,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: fieldBorder,
                                labelText: l10n.sourceLast4Optional,
                                hintText: l10n.sourceLast4Hint,
                                counterText: '',
                                errorText: last4Error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GradientButton(
                          onPressed: () {
                            final rawRecipient = recipientController.text
                                .trim();
                            final normalizedRecipient =
                                selectedRoute.recipientType ==
                                    BankRecipientType.phone
                                ? _normalizePhoneInput(rawRecipient)
                                : _normalizeAccountInput(rawRecipient);
                            final amountRaw = amountController.text.trim();
                            final amount = double.tryParse(amountRaw);
                            final sourceLast4 = last4Controller.text.trim();

                            setSheetState(() {
                              recipientError =
                                  selectedRoute.recipientType ==
                                      BankRecipientType.phone
                                  ? (_phoneDigitsOnly(
                                              normalizedRecipient,
                                            ).length <
                                            10
                                        ? l10n.enterPhoneError
                                        : null)
                                  : (normalizedRecipient.length < 6
                                        ? l10n.enterAccountError
                                        : null);
                              amountError = (amount == null || amount <= 0)
                                  ? l10n.enterAmountError
                                  : null;
                              last4Error =
                                  selectedRoute.requiresSourceLast4 &&
                                      sourceLast4.isNotEmpty &&
                                      !RegExp(r'^\d{4}$').hasMatch(sourceLast4)
                                  ? l10n.invalidLast4Error
                                  : null;
                            });

                            if (recipientError != null ||
                                amountError != null ||
                                last4Error != null) {
                              return;
                            }

                            Navigator.of(ctx).pop(
                              _DirectTransferInputData(
                                countryCode: selectedCountryCode,
                                bank: selectedBank,
                                route: selectedRoute,
                                recipientValue: normalizedRecipient,
                                amount: amount!,
                                sourceLast4:
                                    selectedRoute.requiresSourceLast4 &&
                                        sourceLast4.isNotEmpty
                                    ? sourceLast4
                                    : null,
                              ),
                            );
                          },
                          label: Text(l10n.confirm),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    sheetOpen = false;
    // Keep controllers alive until the route is fully gone; otherwise
    // TextField internals may hit disposed controller during pop animation.
    return result;
  }

  /// Returns null if the user cancelled.
  Future<BankTransferRoute?> _showChannelPickerDialog(
    List<BankTransferRoute> routes,
  ) {
    final l10n = context.l10n;
    return showDialog<BankTransferRoute>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chooseChannelTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: routes
              .map(
                (route) => ListTile(
                  leading: Icon(
                    route.channel == BankTransferChannel.sms
                        ? Icons.sms_outlined
                        : Icons.dialpad,
                  ),
                  title: Text(_routeLabel(route, l10n)),
                  onTap: () => Navigator.of(ctx).pop(route),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  String _routeLabel(BankTransferRoute route, AppLocalizations l10n) {
    return switch ((route.channel, route.recipientType)) {
      (BankTransferChannel.sms, BankRecipientType.phone) => l10n.routeSmsPhone,
      (BankTransferChannel.sms, BankRecipientType.account) =>
        l10n.routeSmsAccount,
      (BankTransferChannel.ussd, BankRecipientType.phone) =>
        l10n.routeUssdPhone,
      (BankTransferChannel.ussd, BankRecipientType.account) =>
        l10n.routeUssdAccount,
    };
  }

  Future<void> _resumeScanning() async {
    final l10n = context.l10n;
    _processing = false;
    await _startScannerIfPossible(reportError: true);
    if (!mounted) {
      return;
    }
    setState(() {
      _hint = l10n.scanningActive;
    });
  }

  Future<bool?> _showLimitWarningDialog({
    required double amount,
    required double remaining,
  }) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.warning_amber, color: Colors.orange, size: 32),
        title: Text(l10n.limitWarningTitle),
        content: Text(
          l10n.limitWarningContent(
            amount.toStringAsFixed(0),
            remaining.toStringAsFixed(0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.sendAnywayButton),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showSentConfirmationDialog() {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirm),
        content: Text(l10n.smsSentSuccess),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          GradientButton(
            onPressed: () => Navigator.of(context).pop(true),
            height: 40,
            label: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  /// Returns the currency symbol for a given ISO currency code.
  String _currencySymbolFor(String currencyCode) {
    return const {
          'RUB': '₽',
          'NGN': '₦',
          'INR': '₹',
          'PKR': '₨',
          'BDT': '৳',
          'IDR': 'Rp',
          'PHP': '₱',
          'VND': '₫',
          'GHS': '₵',
          'AMD': '֏',
          'USD': '\$',
          'EUR': '€',
        }[currencyCode] ??
        currencyCode;
  }

  String _normalizePhoneInput(String rawPhone) {
    final text = rawPhone.trim();
    if (text.isEmpty) return '';
    if (text.startsWith('+')) {
      final digits = text.substring(1).replaceAll(RegExp(r'[^\d]'), '');
      if (digits.isEmpty) return '';
      final limited = digits.length > 15 ? digits.substring(0, 15) : digits;
      return '+$limited';
    }
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length > 15 ? digits.substring(0, 15) : digits;
  }

  String _normalizeAccountInput(String rawValue) {
    return rawValue.trim().replaceAll(RegExp(r'\s+'), '');
  }

  String _phoneDigitsOnly(String rawPhone) {
    return rawPhone.replaceAll(RegExp(r'[^\d]'), '');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_scannerController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final topInset = viewPadding.top + 12;
    final bottomInset = viewPadding.bottom + 12;
    final iconBorderColor = AppColors.green;
    final actionIconStyle = IconButton.styleFrom(
      backgroundColor: Colors.transparent,
      side: BorderSide(color: iconBorderColor, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.actionButtonRadius),
      ),
    );

    if (!widget.controller.permissions.cameraGranted) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.cameraPermissionNeeded,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    await widget.controller.requestCameraPermission();
                    await _startScannerIfPossible(reportError: true);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: Text(l10n.allow),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.back),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              fit: BoxFit.cover,
              onDetect: _onDetect,
              onDetectError: _onScannerError,
              errorBuilder: (ctx, error) => Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.qrError(
                        error.errorDetails?.message ?? 'unknown',
                      ),
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          _startScannerIfPossible(reportError: true),
                      child: Text(context.l10n.scanButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: topInset,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _hint ?? l10n.scanHint,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: bottomInset,
            child: Row(
              children: [
                IconButton.filledTonal(
                  onPressed: _pickFromGallery,
                  style: actionIconStyle,
                  icon: const Icon(Icons.photo_library_outlined),
                  color: iconBorderColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: AppTheme.actionButtonHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.gradient,
                        borderRadius: BorderRadius.circular(
                          AppTheme.actionButtonRadius,
                        ),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        borderRadius: BorderRadius.circular(
                          AppTheme.actionButtonRadius,
                        ),
                        child: InkWell(
                          onTap: _resumeScanning,
                          borderRadius: BorderRadius.circular(
                            AppTheme.actionButtonRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.scanButton,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: l10n.qrAmountButton,
                  onPressed: () => _showGeneratedQr(includeAmount: true),
                  style: actionIconStyle,
                  icon: const Icon(Icons.qr_code_2),
                  color: iconBorderColor,
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: l10n.directTransferButton,
                  onPressed: _startDirectPhoneTransfer,
                  style: actionIconStyle,
                  icon: const Icon(Icons.phone_forwarded_outlined),
                  color: iconBorderColor,
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: l10n.back,
                  onPressed: () => Navigator.of(context).pop(),
                  style: actionIconStyle,
                  icon: const Icon(Icons.arrow_back),
                  color: iconBorderColor,
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: bottomInset + 52,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showGeneratedQr(includeAmount: false),
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 84,
                      height: 84,
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(-6, 0),
                          child: Image.asset(
                            'assets/design/my_qr_icon_button.png',
                            width: 84,
                            height: 84,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandedQr extends StatelessWidget {
  const _BrandedQr({required this.data, required this.size});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = Theme.of(context).colorScheme.primary;
    final logoSize = (size * 0.085).clamp(20.0, 28.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: QrImageView(
        data: data,
        size: size,
        padding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        gapless: false,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.circle,
          color: AppColors.greenDark,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: primary,
        ),
        embeddedImage: const AssetImage('assets/icons/app_icon_source.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(logoSize, logoSize),
        ),
        errorStateBuilder: (ctx, err) =>
            Center(child: Text(l10n.qrError(err ?? 'unknown'))),
      ),
    );
  }
}

class _TransferInputData {
  const _TransferInputData({
    required this.recipientValue,
    required this.recipientType,
    required this.amount,
    this.sourceLast4,
  });

  final String recipientValue;
  final BankRecipientType recipientType;
  final double amount;
  final String? sourceLast4;
}

class _DirectTransferInputData {
  const _DirectTransferInputData({
    required this.countryCode,
    required this.bank,
    required this.route,
    required this.recipientValue,
    required this.amount,
    this.sourceLast4,
  });

  final String countryCode;
  final BankEntry bank;
  final BankTransferRoute route;
  final String recipientValue;
  final double amount;
  final String? sourceLast4;
}

class _ResolvedQrRouting {
  const _ResolvedQrRouting({required this.bank, required this.route});

  final BankEntry bank;
  final BankTransferRoute route;
}
