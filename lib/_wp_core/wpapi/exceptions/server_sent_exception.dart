import 'api_exception.dart';

class ServerSentException extends APIException {
  static const String _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";
  late int errorCode;

  ServerSentException(
    String? errorMessage,
    int errorCode,
  ) : super(errorMessage ?? _USER_READABLE_MESSAGE, "Server sent error: $errorMessage") {
    this.errorCode = errorCode;
  }
}
