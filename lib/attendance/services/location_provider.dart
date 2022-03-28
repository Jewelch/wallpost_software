import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance/exception/location_acquisition_failed_exception.dart';
import 'package:wallpost/attendance/exception/location_address_failed_exception.dart';
import 'package:wallpost/attendance/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance/exception/location_services_disabled_exception.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';



class LocationProvider {
  //Create a new class called Location in entities
  //catch all errors and return a custom error - eg LocationError() in new package called errors
  late bool serviceEnabled;
  late LocationPermission permission;

  Future<AttendanceLocation?> getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print(serviceEnabled);
      if (!serviceEnabled) {
     throw LocationServicesDisabledException();
      }

      // Check location permission is denied.
      permission = await Geolocator.checkPermission();
      print(permission);
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
         throw LocationPermissionsDeniedException();
        }
      }

     // Permissions are denied forever, handle appropriately.
      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionsPermanentlyDeniedException();
      }

      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return AttendanceLocation(position.latitude, position.longitude);
    } catch (e) {
      throw LocationAcquisitionFailedException();
    }

  }

  Future<String?> getLocationAddress(AttendanceLocation attendanceLocation) async {
    try {
      List<Placemark> p =
          await placemarkFromCoordinates(attendanceLocation.latitude.toDouble(),attendanceLocation.longitude.toDouble());
      Placemark place = p[0];
      return "${place.street}";
    } catch (e) {
      throw LocationReverseGeocodingException();
    }
  }
}
// 1. Getting the location - attendance will not work wihtout this - use get location
//     2. getlocationaddress - optional
