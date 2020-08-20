export 'http_exception.dart';
export 'invalid_response_exception.dart';
export 'network_failure_exception.dart';
export 'server_sent_exception.dart';
export 'wrong_response_format_exception.dart';

abstract class APIException implements Exception {
  final String userReadableMessage;
  final String internalErrorMessage;

  APIException(this.userReadableMessage, this.internalErrorMessage);
}
