import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/sms_number_parser.dart';

void main() {
  group('SmsNumberParser', () {
    const parser = SmsNumberParser();

    test('parses grouped number with comma decimal separator', () {
      expect(parser.parseFlexibleNumber('3 637 054,61'), 3637054.61);
    });

    test('parses grouped number with dot decimal separator', () {
      expect(parser.parseFlexibleNumber('1,008,470.48'), 1008470.48);
    });

    test('parses integer with thousands separators', () {
      expect(parser.parseFlexibleNumber('16,950.00'), 16950);
      expect(parser.parseFlexibleNumber('1 200 000'), 1200000);
    });
  });
}
