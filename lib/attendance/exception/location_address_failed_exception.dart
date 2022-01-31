import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationAddressFailedException extends WPException{

  static const _USER_READABLE_MESSAGE = "Getting location address failed.";
  static const _INTERNAL_MESSAGE = "Getting location address failed.";

  LocationAddressFailedException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}