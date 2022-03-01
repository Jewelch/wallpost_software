import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class MissingExpenseRequestData extends WPException {
  static const USER_READABLE_MESSAGE =
      "Oops! Looks like There is Missing expense request data. Please fill it and try again.";
  static const _INTERNAL_MESSAGE = "The required data for expense request is missing";

  MissingExpenseRequestData() : super(USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}
