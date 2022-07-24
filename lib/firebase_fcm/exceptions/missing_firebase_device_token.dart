import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class MissingFirebaseDeviceToken extends WPException {
  static const USER_READABLE_MESSAGE =
      "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "Firebase plugin can't get device token";

  MissingFirebaseDeviceToken() : super(USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}
