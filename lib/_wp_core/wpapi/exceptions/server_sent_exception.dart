// @dart=2.9

import 'api_exception.dart';

class ServerSentException extends APIException {
  static const String _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";
  static const String _INTERNAL_MESSAGE = "";
  int errorCode;

  ServerSentException(
    String errorMessage,
    int errorCode,
  ) : super(errorMessage ?? _USER_READABLE_MESSAGE, _INTERNAL_MESSAGE) {
    this.errorCode = errorCode;
  }
}
