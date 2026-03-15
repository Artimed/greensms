import 'package:zelenaya_sms/l10n/app_localizations.dart';

import '../../features/sms/domain/entities/operation_type.dart';

extension OperationTypeL10nX on OperationType {
  String localizedShort(AppLocalizations l10n) {
    return switch (this) {
      OperationType.incoming => l10n.opIncoming,
      OperationType.outgoing => l10n.opOutgoing,
      OperationType.transfer => l10n.opTransfer,
      OperationType.unknown => l10n.opUnknown,
    };
  }
}
