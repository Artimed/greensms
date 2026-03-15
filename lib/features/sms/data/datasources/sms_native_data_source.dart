import 'package:flutter/services.dart';

import '../../domain/entities/sms_message.dart';

class SmsNativeDataSource {
  static const MethodChannel _methodChannel = MethodChannel(
    'zelenaya_sms/sms_method',
  );
  static const EventChannel _eventChannel = EventChannel(
    'zelenaya_sms/sms_events',
  );

  Future<List<SmsMessage>> readLatest({required int limit}) async {
    final response = await _methodChannel.invokeMethod<List<dynamic>>(
      'readLatestSms',
      {'limit': limit},
    );

    if (response == null) {
      return const <SmsMessage>[];
    }

    return response
        .whereType<Map<Object?, Object?>>()
        .map(SmsMessage.fromNative)
        .toList();
  }

  Future<void> sendDirectSms({
    required String address,
    required String body,
  }) async {
    await _methodChannel.invokeMethod<void>('sendDirectSms', {
      'address': address,
      'body': body,
    });
  }

  Stream<SmsMessage> incomingSms() {
    return _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is Map<Object?, Object?>)
        .map((event) => SmsMessage.fromNative(event as Map<Object?, Object?>));
  }
}
