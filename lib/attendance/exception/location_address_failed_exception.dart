import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationReverseGeocodingException extends WPException{

  static const _USER_READABLE_MESSAGE = "Failed to get address";
  static const _INTERNAL_MESSAGE = "Failed to get address";

  LocationReverseGeocodingException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}