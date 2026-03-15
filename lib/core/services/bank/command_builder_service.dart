import '../../../features/qr/domain/entities/qr_payload.dart';
import 'bank_models.dart';

sealed class CommandResult {
  const CommandResult();
}

class TransferCommandInput {
  const TransferCommandInput({
    required this.recipientValue,
    required this.amount,
    this.sourceLast4,
  });

  final String recipientValue;
  final double amount;
  final String? sourceLast4;
}

class SmsCommandResult extends CommandResult {
  const SmsCommandResult({required this.number, required this.body});
  final String number;
  final String body;
}

class UssdCommandResult extends CommandResult {
  const UssdCommandResult({required this.uri, required this.display});

  /// Android tel URI: "tel:*737*1*1000*0123456789%23"
  final String uri;

  /// Human-readable code shown in dialog: "*737*1*1000*0123456789#"
  final String display;
}

class CommandBuilderService {
  /// Build the appropriate command (SMS or USSD) for the given bank and QR
  /// payload. Returns null if the amount is missing or the template cannot
  /// be rendered (e.g. requires a PIN input not yet supported).
  CommandResult? buildCommand(BankEntry bank, QrPayload payload) {
    final recipientType = payload.recipientType == QrRecipientType.account
        ? BankRecipientType.account
        : BankRecipientType.phone;
    final route = bank.supportedRoutes
        .where((candidate) => candidate.recipientType == recipientType)
        .firstOrNull;
    if (route == null || payload.amount == null || payload.amount! <= 0) {
      return null;
    }

    return buildRouteCommand(
      bank: bank,
      route: route,
      input: TransferCommandInput(
        recipientValue: payload.recipientValue,
        amount: payload.amount!,
        sourceLast4: payload.sourceLast4,
      ),
    );
  }

  CommandResult? buildRouteCommand({
    required BankEntry bank,
    required BankTransferRoute route,
    required TransferCommandInput input,
  }) {
    if (input.amount <= 0 || input.recipientValue.trim().isEmpty) {
      return null;
    }
    return switch (route.channel) {
      BankTransferChannel.sms => _buildSms(bank, route, input),
      BankTransferChannel.ussd => _buildUssd(bank, route, input),
    };
  }

  SmsCommandResult? _buildSms(
    BankEntry bank,
    BankTransferRoute route,
    TransferCommandInput input,
  ) {
    final template = bank.sms.template!;
    final number = bank.sms.number!;
    final recipient = _normalizeRecipient(
      value: input.recipientValue,
      countryCode: bank.countryCode,
      type: route.recipientType,
    );
    var body = template
        .replaceAll('{phone}', recipient)
        .replaceAll('{account}', recipient)
        .replaceAll('{amount}', input.amount.toStringAsFixed(0));

    if (template.contains('{last4}')) {
      final last4 = input.sourceLast4 ?? '';
      body = body.replaceAll('{last4}', last4).trim();
    }

    return SmsCommandResult(number: number, body: body.trim());
  }

  UssdCommandResult? _buildUssd(
    BankEntry bank,
    BankTransferRoute route,
    TransferCommandInput input,
  ) {
    final template = bank.ussd.template!;
    // {pin} requires user PIN — not supported in this flow
    if (template.contains('{pin}')) return null;

    final recipient = _normalizeRecipient(
      value: input.recipientValue,
      countryCode: bank.countryCode,
      type: route.recipientType,
    );
    final display = template
        .replaceAll('{phone}', recipient)
        .replaceAll('{account}', recipient)
        .replaceAll('{amount}', input.amount.toStringAsFixed(0));

    final uri = 'tel:${display.replaceAll('#', '%23')}';
    return UssdCommandResult(uri: uri, display: display);
  }

  String _normalizeRecipient({
    required String value,
    required String countryCode,
    required BankRecipientType type,
  }) {
    if (type == BankRecipientType.account) {
      return value.trim().replaceAll(RegExp(r'\s+'), '');
    }
    return _normalizePhone(value, countryCode);
  }

  String _normalizePhone(String phone, String countryCode) {
    if (countryCode == 'RU') {
      final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.length == 10) return '7$digits';
      if (digits.length == 11 && digits.startsWith('8')) {
        return '7${digits.substring(1)}';
      }
      return digits;
    }
    return phone.trim();
  }
}
