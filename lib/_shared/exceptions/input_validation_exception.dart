import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class InputValidationException extends WPException {
  InputValidationException(String errorMessage) : super(errorMessage, errorMessage);
}
