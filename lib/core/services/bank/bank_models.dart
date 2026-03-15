class CountryEntry {
  const CountryEntry({
    required this.countryCode,
    required this.countryName,
    required this.locale,
    required this.currency,
    this.languages = const [],
  });

  final String countryCode;
  final String countryName;
  final String locale;
  final String currency;
  final List<String> languages;
}

enum BankTransferChannel { sms, ussd }

enum BankRecipientType { phone, account }

class BankTransferRoute {
  const BankTransferRoute({
    required this.id,
    required this.channel,
    required this.recipientType,
    required this.requiresSourceLast4,
  });

  final String id;
  final BankTransferChannel channel;
  final BankRecipientType recipientType;
  final bool requiresSourceLast4;
}

class SmsTemplateConfig {
  const SmsTemplateConfig({
    required this.enabled,
    required this.routingEnabled,
    this.number,
    this.template,
    this.variables = const [],
    this.example,
  });

  final bool enabled;
  final bool routingEnabled;
  final String? number;
  final String? template;
  final List<String> variables;
  final String? example;

  factory SmsTemplateConfig.fromJson(Map<String, dynamic> json) {
    final enabled = json['enabled'] as bool? ?? false;
    return SmsTemplateConfig(
      enabled: enabled,
      routingEnabled: json['routing_enabled'] as bool? ?? enabled,
      number: json['number'] as String?,
      template: json['template'] as String?,
      variables:
          (json['variables'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      example: json['example'] as String?,
    );
  }
}

class UssdTemplateConfig {
  const UssdTemplateConfig({
    required this.enabled,
    required this.routingEnabled,
    this.template,
    this.variables = const [],
    this.example,
  });

  final bool enabled;
  final bool routingEnabled;
  final String? template;
  final List<String> variables;
  final String? example;

  factory UssdTemplateConfig.fromJson(Map<String, dynamic> json) {
    final enabled = json['enabled'] as bool? ?? false;
    return UssdTemplateConfig(
      enabled: enabled,
      routingEnabled: json['routing_enabled'] as bool? ?? enabled,
      template: json['template'] as String?,
      variables:
          (json['variables'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      example: json['example'] as String?,
    );
  }
}

class BankParserExample {
  const BankParserExample({
    required this.type,
    required this.language,
    required this.text,
  });

  final String type;
  final String language;
  final String text;
}

class BankLimitItem {
  const BankLimitItem({
    required this.label,
    required this.value,
    required this.isWarning,
  });

  final String label;
  final String value;
  final bool isWarning;

  factory BankLimitItem.fromJson(Map<String, dynamic> json) {
    return BankLimitItem(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      isWarning: json['is_warning'] as bool? ?? false,
    );
  }
}

class BankEntry {
  const BankEntry({
    required this.bankId,
    required this.bankName,
    required this.countryCode,
    required this.currency,
    required this.locale,
    required this.priority,
    required this.status,
    this.tier,
    required this.sms,
    required this.ussd,
    this.parserExamples = const [],
    this.officialWebsite,
    this.helpNumber,
    this.officialStatus,
    this.panelChannel,
    this.lastVerifiedAt,
    this.officialSources = const [],
    this.transferLimits = const [],
    this.transferFees = const [],
    this.bankRules = const [],
  });

  final String bankId;
  final String bankName;
  final String countryCode;
  final String currency;
  final String locale;
  final String priority;
  final String status;
  final int? tier;
  final SmsTemplateConfig sms;
  final UssdTemplateConfig ussd;
  final List<BankParserExample> parserExamples;
  final String? officialWebsite;
  final String? helpNumber;
  final String? officialStatus;
  final String? panelChannel;
  final String? lastVerifiedAt;
  final List<String> officialSources;
  final List<BankLimitItem> transferLimits;
  final List<BankLimitItem> transferFees;
  final List<String> bankRules;

  bool get canSendSms =>
      sms.enabled &&
      sms.routingEnabled &&
      sms.template != null &&
      sms.number != null;
  bool get hasSmsTemplateConfigured =>
      sms.enabled && sms.template != null && sms.number != null;
  bool get canSendUssd =>
      ussd.enabled && ussd.routingEnabled && ussd.template != null;
  bool get hasUssdTemplateConfigured => ussd.enabled && ussd.template != null;
  bool get isOperational => canSendSms || canSendUssd;
  bool get isVerified => status == 'verified';
  bool get isVerifiedPublic => officialStatus == 'verified_public';
  bool get isLimitedPublic => officialStatus == 'limited_public';
  bool get requiresManualVerification =>
      officialStatus == 'manual_verification_required';

  List<BankTransferRoute> get supportedRoutes {
    final routes = <BankTransferRoute>[];

    final smsRecipientType = _inferRecipientType(
      template: sms.template,
      variables: sms.variables,
    );
    if (canSendSms && smsRecipientType != null) {
      routes.add(
        BankTransferRoute(
          id: '$bankId:sms:${smsRecipientType.name}',
          channel: BankTransferChannel.sms,
          recipientType: smsRecipientType,
          requiresSourceLast4: (sms.template ?? '').contains('{last4}'),
        ),
      );
    }

    final ussdRecipientType = _inferRecipientType(
      template: ussd.template,
      variables: ussd.variables,
    );
    if (canSendUssd && ussdRecipientType != null) {
      routes.add(
        BankTransferRoute(
          id: '$bankId:ussd:${ussdRecipientType.name}',
          channel: BankTransferChannel.ussd,
          recipientType: ussdRecipientType,
          requiresSourceLast4: false,
        ),
      );
    }

    routes.sort((a, b) {
      final recipientCmp = _recipientPriority(
        a.recipientType,
      ).compareTo(_recipientPriority(b.recipientType));
      if (recipientCmp != 0) return recipientCmp;
      return _channelPriority(a.channel).compareTo(_channelPriority(b.channel));
    });
    return routes;
  }

  static int _recipientPriority(BankRecipientType type) {
    return switch (type) {
      BankRecipientType.account => 0,
      BankRecipientType.phone => 1,
    };
  }

  static int _channelPriority(BankTransferChannel channel) {
    return switch (channel) {
      BankTransferChannel.sms => 0,
      BankTransferChannel.ussd => 1,
    };
  }

  static BankRecipientType? _inferRecipientType({
    required String? template,
    required List<String> variables,
  }) {
    final normalizedVariables = variables.map((value) => value.toLowerCase());
    final normalizedTemplate = (template ?? '').toLowerCase();

    final hasAccount =
        normalizedVariables.contains('account') ||
        normalizedTemplate.contains('{account}');
    final hasPhone =
        normalizedVariables.contains('phone') ||
        normalizedTemplate.contains('{phone}');

    if (hasAccount) return BankRecipientType.account;
    if (hasPhone) return BankRecipientType.phone;
    return null;
  }
}
