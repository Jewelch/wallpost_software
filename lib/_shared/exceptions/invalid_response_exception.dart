import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class InvalidResponseException extends WPException {
  static const _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "The response is invalid";

  InvalidResponseException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}
