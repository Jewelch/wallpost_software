import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationPermissionsPermanentlyDeniedException extends WPException{

  static const _USER_READABLE_MESSAGE = "Location permission is permanently denied, we cannot request permissions";
  static const _INTERNAL_MESSAGE = "Location permission is permanently denied, we cannot request permissions.";

  LocationPermissionsPermanentlyDeniedException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}