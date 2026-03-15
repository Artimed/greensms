import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/core/services/bank/bank_registry_service.dart';

void main() {
  group('BankRegistryService', () {
    test(
      'loads countries and resolves primary bank by locale/country',
      () async {
        final service = BankRegistryService(loader: () async => _fixtureJson);
        await service.load();

        final countries = service.getCountries();
        expect(countries.map((c) => c.countryCode), containsAll(['RU', 'NG']));

        final ruBank = service.getPrimaryBankForLocale('ru-RU');
        expect(ruBank, isNotNull);
        expect(ruBank!.bankId, 'sberbank_ru');

        // Language-only fallback en -> en-NG
        final enFallback = service.getPrimaryBankForLocale('en');
        expect(enFallback, isNotNull);
        expect(enFallback!.bankId, 'gtbank_ng');

        final ngBank = service.getPrimaryBankForCountry('NG');
        expect(ngBank, isNotNull);
        expect(ngBank!.bankId, 'gtbank_ng');
      },
    );

    test('filters only operational banks for country', () async {
      final service = BankRegistryService(loader: () async => _fixtureJson);
      await service.load();

      final ruBanks = service.getOperationalBanksForCountry('RU');
      expect(ruBanks.length, 1);
      expect(ruBanks.single.bankId, 'sberbank_ru');
    });

    test(
      'excludes countries without operational banks from default list',
      () async {
        final service = BankRegistryService(loader: () async => _fixtureJson);
        await service.load();

        final countries = service.getCountries();
        expect(countries.map((c) => c.countryCode), isNot(contains('VN')));

        final allCountries = service.getCountries(operationalOnly: false);
        expect(allCountries.map((c) => c.countryCode), containsAll(['VN', 'ID']));
      },
    );

    test('does not treat routing-disabled templates as operational', () async {
      final service = BankRegistryService(loader: () async => _fixtureJson);
      await service.load();

      final idBanks = service.getOperationalBanksForCountry('ID');
      expect(idBanks, isEmpty);

      final allCountries = service.getCountries(operationalOnly: false);
      expect(allCountries.map((c) => c.countryCode), contains('ID'));
    });
  });
}

const String _fixtureJson = '''
{
  "countries": [
    {
      "country_code": "RU",
      "country_name": "Russia",
      "locale": "ru-RU",
      "currency": "RUB",
      "languages": ["ru"],
      "banks": [
        {
          "bank_id": "sberbank_ru",
          "bank_name": "Sberbank",
          "priority": "primary",
          "status": "verified",
          "sms": {
            "enabled": true,
            "number": "900",
            "template": "ПЕРЕВОД {phone} {amount}",
            "variables": ["phone", "amount"]
          },
          "ussd": {
            "enabled": false,
            "template": null,
            "variables": []
          }
        },
        {
          "bank_id": "tbank_ru",
          "bank_name": "T-Bank",
          "priority": "secondary",
          "status": "needs_manual_verification",
          "sms": {
            "enabled": false,
            "number": null,
            "template": null,
            "variables": []
          },
          "ussd": {
            "enabled": false,
            "template": null,
            "variables": []
          }
        }
      ]
    },
    {
      "country_code": "VN",
      "country_name": "Vietnam",
      "locale": "vi-VN",
      "currency": "VND",
      "languages": ["vi"],
      "banks": [
        {
          "bank_id": "vietcombank_vn",
          "bank_name": "Vietcombank",
          "priority": "primary",
          "status": "excluded",
          "sms": {
            "enabled": false,
            "number": null,
            "template": null,
            "variables": []
          },
          "ussd": {
            "enabled": false,
            "template": null,
            "variables": []
          }
        }
      ]
    },
    {
      "country_code": "ID",
      "country_name": "Indonesia",
      "locale": "id-ID",
      "currency": "IDR",
      "languages": ["id"],
      "banks": [
        {
          "bank_id": "mandiri_id",
          "bank_name": "Bank Mandiri",
          "priority": "primary",
          "status": "needs_verification",
          "official_status": "limited_public",
          "panel_channel": "sms_notifications_plus_app",
          "sms": {
            "enabled": true,
            "routing_enabled": false,
            "number": "83355",
            "template": "TRF {phone} {amount}",
            "variables": ["phone", "amount"]
          },
          "ussd": {
            "enabled": false,
            "template": null,
            "variables": []
          }
        }
      ]
    },
    {
      "country_code": "NG",
      "country_name": "Nigeria",
      "locale": "en-NG",
      "currency": "NGN",
      "languages": ["en"],
      "banks": [
        {
          "bank_id": "gtbank_ng",
          "bank_name": "GTBank",
          "priority": "primary",
          "status": "verified",
          "sms": {
            "enabled": false,
            "number": null,
            "template": null,
            "variables": []
          },
          "ussd": {
            "enabled": true,
            "template": "*737*1*{amount}*{account}#",
            "variables": ["amount", "account"]
          }
        }
      ]
    }
  ]
}
''';
