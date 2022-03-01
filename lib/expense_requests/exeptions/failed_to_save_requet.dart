import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class FailedToSaveRequest extends WPException {
  static const USER_READABLE_MESSAGE =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "The required data for expense request is missing";

  FailedToSaveRequest() : super(USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}
