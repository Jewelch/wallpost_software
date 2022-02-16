import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationServicesDisabledException extends WPException {
  static const _USER_READABLE_MESSAGE = "Location services are disabled";
  static const _INTERNAL_MESSAGE = "Location services are disabled";

  LocationServicesDisabledException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}
