import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class MoneyInitializationException extends WPException {
  MoneyInitializationException(String message) : super(message, message);
}
