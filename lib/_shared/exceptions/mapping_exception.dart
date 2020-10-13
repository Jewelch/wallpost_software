import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class MappingException extends WPException {
  static const String _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";

  MappingException(String errorMessage) : super(_USER_READABLE_MESSAGE, errorMessage);
}
