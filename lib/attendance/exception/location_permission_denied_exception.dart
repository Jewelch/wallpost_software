import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationPermissionsDeniedException extends WPException{

  static const _USER_READABLE_MESSAGE = "Location permission is denied";
  static const _INTERNAL_MESSAGE = "Location permission is denied.";

  LocationPermissionsDeniedException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}