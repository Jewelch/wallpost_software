import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class InvalidExpenseDataException extends WPException {
  InvalidExpenseDataException(String message) : super(message, message);
}
