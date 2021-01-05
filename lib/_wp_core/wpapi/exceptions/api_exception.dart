import 'package:wallpost/_shared/exceptions/wp_exception.dart';

export '../../../_shared/exceptions/invalid_response_exception.dart';
export 'http_exception.dart';
export 'malformed_response_exception.dart';
export 'network_failure_exception.dart';
export 'request_exception.dart';
export 'server_sent_exception.dart';
export 'unexpected_response_format_exception.dart';

class APIException extends WPException {
  final dynamic responseData;

  APIException(
    String userReadableMessage,
    String internalErrorMessage, {
    this.responseData,
  }) : super(userReadableMessage, internalErrorMessage);
}
