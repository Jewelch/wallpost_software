import 'api_exception.dart';

class RequestException extends APIException {
  static const String _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";

  RequestException(String errorMessage) : super(_USER_READABLE_MESSAGE, errorMessage);
}
