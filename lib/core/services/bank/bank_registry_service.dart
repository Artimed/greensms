import 'dart:convert';

import 'package:flutter/services.dart';

import 'bank_models.dart';

typedef BankRegistryLoader = Future<String> Function();

class BankRegistryService {
  BankRegistryService({BankRegistryLoader? loader})
    : _loader =
          loader ?? (() => rootBundle.loadString('assets/data/sms_banks.json'));

  final List<BankEntry> _banks = [];
  final List<CountryEntry> _countries = [];
  final BankRegistryLoader _loader;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final jsonStr = await _loader();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final countries = data['countries'] as List<dynamic>;
    for (final country in countries) {
      final c = country as Map<String, dynamic>;
      final countryCode = c['country_code'] as String;
      final countryName = c['country_name'] as String? ?? countryCode;
      final currency = c['currency'] as String;
      final locale = c['locale'] as String;
      _countries.add(
        CountryEntry(
          countryCode: countryCode,
          countryName: countryName,
          locale: locale,
          currency: currency,
          languages: (c['languages'] as List<dynamic>? ?? <dynamic>[])
              .map((e) => e.toString())
              .toList(),
        ),
      );
      for (final bank in (c['banks'] as List<dynamic>)) {
        final b = bank as Map<String, dynamic>;
        _banks.add(
          BankEntry(
            bankId: b['bank_id'] as String,
            bankName: b['bank_name'] as String,
            countryCode: countryCode,
            currency: currency,
            locale: locale,
            priority: b['priority'] as String? ?? 'secondary',
            status: b['status'] as String? ?? 'needs_verification',
            tier: b['tier'] as int?,
            sms: SmsTemplateConfig.fromJson(b['sms'] as Map<String, dynamic>),
            ussd: UssdTemplateConfig.fromJson(
              b['ussd'] as Map<String, dynamic>,
            ),
            parserExamples:
                (b['parser_examples'] as List<dynamic>? ?? []).map((e) {
                  final ex = e as Map<String, dynamic>;
                  return BankParserExample(
                    type: ex['type'] as String? ?? '',
                    language: ex['language'] as String? ?? 'en',
                    text: ex['text'] as String? ?? '',
                  );
                }).toList(),
            officialWebsite: b['official_website'] as String?,
            helpNumber: b['help_number'] as String?,
            officialStatus: b['official_status'] as String?,
            panelChannel: b['panel_channel'] as String?,
            lastVerifiedAt: b['last_verified_at'] as String?,
            officialSources:
                (b['official_sources'] as List<dynamic>? ?? <dynamic>[])
                    .map((e) => e.toString())
                    .toList(),
            transferLimits:
                (b['transfer_limits'] as List<dynamic>? ?? [])
                    .map(
                      (e) =>
                          BankLimitItem.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
            transferFees:
                (b['transfer_fees'] as List<dynamic>? ?? [])
                    .map(
                      (e) =>
                          BankLimitItem.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
            bankRules:
                (b['bank_rules'] as List<dynamic>? ?? [])
                    .map((e) => e.toString())
                    .toList(),
          ),
        );
      }
    }
    _loaded = true;
  }

  BankEntry? getBankById(String id) =>
      _banks.where((b) => b.bankId == id).firstOrNull;

  CountryEntry? getCountryByCode(String countryCode) =>
      _countries.where((c) => c.countryCode == countryCode).firstOrNull;

  List<CountryEntry> getCountries({bool operationalOnly = true}) {
    if (!operationalOnly) {
      return List<CountryEntry>.from(_countries);
    }
    return _countries
        .where(
          (country) => _banks.any(
            (bank) =>
                bank.countryCode == country.countryCode && bank.isOperational,
          ),
        )
        .toList();
  }

  List<BankEntry> getBanksForCountry(String countryCode) {
    final normalized = countryCode.toUpperCase();
    return _banks.where((b) => b.countryCode == normalized).toList();
  }

  List<BankEntry> getOperationalBanksForCountry(String countryCode) {
    return getBanksForCountry(
      countryCode,
    ).where((b) => b.isOperational).toList();
  }

  BankEntry? getPrimaryBankForCountry(String countryCode) {
    final operational = getOperationalBanksForCountry(countryCode);
    final primary = operational
        .where((b) => b.priority == 'primary')
        .firstOrNull;
    return primary ?? operational.firstOrNull;
  }

  /// Returns the primary operational bank for the given locale tag
  /// (e.g. "ru-RU", "en-NG"). Tries exact match first, then language-only.
  BankEntry? getPrimaryBankForLocale(String locale) {
    final normalized = locale.replaceAll('_', '-').toLowerCase();

    final exact = _banks
        .where(
          (b) =>
              b.locale.toLowerCase() == normalized &&
              b.priority == 'primary' &&
              b.isOperational,
        )
        .firstOrNull;
    if (exact != null) return exact;

    // Language-only fallback (e.g. "ru" matches "ru-RU")
    final lang = normalized.split('-').first;
    return _banks
        .where(
          (b) =>
              b.locale.toLowerCase().startsWith(lang) &&
              b.priority == 'primary' &&
              b.isOperational,
        )
        .firstOrNull;
  }

  List<BankEntry> getBanksForLocale(String locale) {
    final normalized = locale.replaceAll('_', '-').toLowerCase();
    return _banks.where((b) => b.locale.toLowerCase() == normalized).toList();
  }
}
