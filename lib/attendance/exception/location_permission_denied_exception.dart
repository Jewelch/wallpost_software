import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationPermissionsDeniedException extends WPException{

  static const _USER_READABLE_MESSAGE = "Location permissions are denied";
  static const _INTERNAL_MESSAGE = "Location permissions are denied.";

  LocationPermissionsDeniedException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}