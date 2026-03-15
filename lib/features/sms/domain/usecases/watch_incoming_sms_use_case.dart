import '../../data/parsing/sms_parser.dart';
import '../entities/sms_message.dart';
import '../repositories/sms_repository.dart';

class WatchIncomingSmsUseCase {
  WatchIncomingSmsUseCase({
    required SmsRepository repository,
    required SmsParser parser,
  }) : _repository = repository,
       _parser = parser;

  final SmsRepository _repository;
  final SmsParser _parser;

  Stream<SmsMessage> call() {
    return _repository.incomingSms().map(_parser.parse);
  }
}
