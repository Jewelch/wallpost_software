import 'package:wallpost/_shared/exceptions/wp_exception.dart';

export 'http_exception.dart';
export 'invalid_response_exception.dart';
export 'network_failure_exception.dart';
export 'request_exception.dart';
export 'server_sent_exception.dart';
export 'wrong_response_format_exception.dart';

class APIException extends WPException {
  APIException(
    String userReadableMessage,
    String internalErrorMessage,
  ) : super(userReadableMessage, internalErrorMessage);
}
