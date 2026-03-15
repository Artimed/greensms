import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/core/services/bank/bank_models.dart';
import 'package:zelenaya_sms/core/services/bank/command_builder_service.dart';
import 'package:zelenaya_sms/features/qr/domain/entities/qr_payload.dart';

void main() {
  group('CommandBuilderService', () {
    final service = CommandBuilderService();

    test('builds SMS command and normalizes RU phone', () {
      final bank = BankEntry(
        bankId: 'sberbank_ru',
        bankName: 'Sberbank',
        countryCode: 'RU',
        currency: 'RUB',
        locale: 'ru-RU',
        priority: 'primary',
        status: 'verified',
        tier: 1,
        sms: const SmsTemplateConfig(
          enabled: true,
          routingEnabled: true,
          number: '900',
          template: 'ПЕРЕВОД {phone} {amount} {last4}',
        ),
        ussd: const UssdTemplateConfig(
          enabled: false,
          routingEnabled: false,
          template: null,
        ),
      );
      const payload = QrPayload(
        recipientValue: '89161234567',
        amount: 1250,
        sourceLast4: '1234',
      );

      final result = service.buildCommand(bank, payload);
      expect(result, isA<SmsCommandResult>());
      final sms = result! as SmsCommandResult;
      expect(sms.number, '900');
      expect(sms.body, 'ПЕРЕВОД 79161234567 1250 1234');
    });

    test('returns null for SMS when amount is missing', () {
      final bank = BankEntry(
        bankId: 'sberbank_ru',
        bankName: 'Sberbank',
        countryCode: 'RU',
        currency: 'RUB',
        locale: 'ru-RU',
        priority: 'primary',
        status: 'verified',
        tier: 1,
        sms: const SmsTemplateConfig(
          enabled: true,
          routingEnabled: true,
          number: '900',
          template: 'ПЕРЕВОД {phone} {amount}',
        ),
        ussd: const UssdTemplateConfig(
          enabled: false,
          routingEnabled: false,
          template: null,
        ),
      );
      const payload = QrPayload(recipientValue: '+79991234567');

      final result = service.buildCommand(bank, payload);
      expect(result, isNull);
    });

    test('builds account-based USSD command and escapes hash in tel URI', () {
      final bank = BankEntry(
        bankId: 'gtbank_ng',
        bankName: 'GTBank',
        countryCode: 'NG',
        currency: 'NGN',
        locale: 'en-NG',
        priority: 'primary',
        status: 'verified',
        tier: 3,
        sms: const SmsTemplateConfig(
          enabled: false,
          routingEnabled: false,
          template: null,
        ),
        ussd: const UssdTemplateConfig(
          enabled: true,
          routingEnabled: true,
          template: '*737*1*{amount}*{account}#',
        ),
      );
      final route = bank.supportedRoutes.single;

      final result = service.buildRouteCommand(
        bank: bank,
        route: route,
        input: const TransferCommandInput(
          recipientValue: '0123456789',
          amount: 1000,
        ),
      );
      expect(result, isA<UssdCommandResult>());
      final ussd = result! as UssdCommandResult;
      expect(ussd.display, '*737*1*1000*0123456789#');
      expect(ussd.uri, 'tel:*737*1*1000*0123456789%23');
    });

    test('does not build generic QR command for account-only route', () {
      final bank = BankEntry(
        bankId: 'gtbank_ng',
        bankName: 'GTBank',
        countryCode: 'NG',
        currency: 'NGN',
        locale: 'en-NG',
        priority: 'primary',
        status: 'verified',
        tier: 3,
        sms: const SmsTemplateConfig(
          enabled: false,
          routingEnabled: false,
          template: null,
        ),
        ussd: const UssdTemplateConfig(
          enabled: true,
          routingEnabled: true,
          template: '*737*1*{amount}*{account}#',
        ),
      );

      const payload = QrPayload(recipientValue: '0123456789', amount: 1000);
      final result = service.buildCommand(bank, payload);
      expect(result, isNull);
    });

    test('returns null for USSD template requiring PIN', () {
      final bank = BankEntry(
        bankId: 'vodafone_gh',
        bankName: 'Vodafone Cash',
        countryCode: 'GH',
        currency: 'GHS',
        locale: 'en-GH',
        priority: 'primary',
        status: 'needs_verification',
        tier: 3,
        sms: const SmsTemplateConfig(
          enabled: false,
          routingEnabled: false,
          template: null,
        ),
        ussd: const UssdTemplateConfig(
          enabled: true,
          routingEnabled: true,
          template: '*170*2*1*{phone}*{phone}*{amount}*{pin}#',
        ),
      );
      const payload = QrPayload(recipientValue: '0500000000', amount: 100);

      final result = service.buildCommand(bank, payload);
      expect(result, isNull);
    });

    test('returns null for SMS when runtime routing is disabled', () {
      final bank = BankEntry(
        bankId: 'mandiri_id',
        bankName: 'Bank Mandiri',
        countryCode: 'ID',
        currency: 'IDR',
        locale: 'id-ID',
        priority: 'primary',
        status: 'needs_verification',
        tier: 1,
        sms: const SmsTemplateConfig(
          enabled: true,
          routingEnabled: false,
          number: '83355',
          template: 'TRF {phone} {amount}',
        ),
        ussd: const UssdTemplateConfig(
          enabled: false,
          routingEnabled: false,
          template: null,
        ),
      );
      const payload = QrPayload(recipientValue: '08123456789', amount: 100000);

      final result = service.buildCommand(bank, payload);
      expect(result, isNull);
      expect(bank.isOperational, isFalse);
    });
  });
}
