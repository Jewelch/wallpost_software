import 'package:wallpost/_shared/exceptions/wp_exception.dart';

class LocationAcquisitionFailedException extends WPException{

  static const _USER_READABLE_MESSAGE = "Getting location failed.";
  static const _INTERNAL_MESSAGE = "Getting location failed.";

  LocationAcquisitionFailedException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}