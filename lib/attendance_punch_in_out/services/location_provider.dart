import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_address_failed_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_services_disabled_exception.dart';

import '../exception/location_acquisition_failed_exception.dart';

class LocationProvider {
  late bool serviceEnabled;
  late LocationPermission permission;

  Future<AttendanceLocation> getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      print("00000-----");
      //Checking if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServicesDisabledException();
      }

      print("11111-----");
      //Checking if location permissions are denied
      //If denied, we request the permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationPermissionsDeniedException();
        }
      }
      print("22222-----");
      // Permissions are denied forever
      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionsPermanentlyDeniedException();
      }
      print("33333-----");
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return AttendanceLocation(position.latitude, position.longitude);
    } catch (e) {
      if (e is LocationServicesDisabledException ||
          e is LocationPermissionsDeniedException ||
          e is LocationPermissionsPermanentlyDeniedException) {
        rethrow;
      }

      throw LocationAcquisitionFailedException();
    }
  }

  Future<String> getLocationAddress(AttendanceLocation attendanceLocation) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          attendanceLocation.latitude.toDouble(), attendanceLocation.longitude.toDouble());
      Placemark place = p[0];
      return "${place.street}";
    } catch (e) {
      throw LocationReverseGeocodingException();
    }
  }
}
