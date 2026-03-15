class SmsNumberParser {
  const SmsNumberParser();

  double? parseFlexibleNumber(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    var clean = raw.replaceAll(RegExp(r'[\s\u00A0]'), '');

    final hasComma = clean.contains(',');
    final hasDot = clean.contains('.');

    if (hasComma && hasDot) {
      final lastComma = clean.lastIndexOf(',');
      final lastDot = clean.lastIndexOf('.');
      final decimalSeparator = lastComma > lastDot ? ',' : '.';
      final thousandsSeparator = decimalSeparator == ',' ? '.' : ',';
      clean = clean.replaceAll(thousandsSeparator, '');
      if (decimalSeparator == ',') {
        clean = clean.replaceAll(',', '.');
      } else {
        clean = clean.replaceAll(',', '');
      }
    } else if (hasComma) {
      clean = _normalizeSingleSeparator(clean, ',');
    } else if (hasDot) {
      clean = _normalizeSingleSeparator(clean, '.');
    }

    return double.tryParse(clean);
  }

  String _normalizeSingleSeparator(String value, String separator) {
    final parts = value.split(separator);
    if (parts.length == 1) return value;

    final tail = parts.last;
    final head = parts.sublist(0, parts.length - 1).join();
    final decimalLike = tail.length <= 2 && head.isNotEmpty;

    if (decimalLike) {
      return '$head.$tail';
    }

    return parts.join();
  }
}
