import 'package:intl/intl.dart';

class Formatters {
  static final Map<String, NumberFormat> _moneyFormats =
      <String, NumberFormat>{};

  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  static String money(double? value, {String currencyCode = 'RUB'}) {
    if (value == null) {
      return '—';
    }
    final normalized = currencyCode.trim().toUpperCase();
    final format = _moneyFormats.putIfAbsent(normalized, () {
      return NumberFormat.currency(
        locale: _localeForCurrency(normalized),
        symbol: currencySymbolFor(normalized),
        decimalDigits: 0,
      );
    });
    return format.format(value);
  }

  static String time(DateTime value) => _timeFormat.format(value);

  static String dateTime(DateTime value) => _dateTimeFormat.format(value);

  static String currencySymbolFor(String currencyCode) {
    final normalized = currencyCode.trim().toUpperCase();
    return switch (normalized) {
      'RUB' => '₽',
      'INR' => '₹',
      'PKR' => '₨',
      'BDT' => '৳',
      'NGN' => '₦',
      'GHS' => '₵',
      'IDR' => 'Rp',
      'PHP' => '₱',
      'VND' => '₫',
      'AMD' => '֏',
      _ => normalized,
    };
  }

  static String _localeForCurrency(String currencyCode) {
    return switch (currencyCode) {
      'RUB' => 'ru_RU',
      'INR' => 'en_IN',
      'PKR' => 'en_PK',
      'BDT' => 'bn_BD',
      'NGN' => 'en_NG',
      'GHS' => 'en_GH',
      'IDR' => 'id_ID',
      'PHP' => 'en_PH',
      'VND' => 'vi_VN',
      'AMD' => 'hy_AM',
      _ => 'en_US',
    };
  }
}
