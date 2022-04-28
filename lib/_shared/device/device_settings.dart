import 'package:geolocator/geolocator.dart';

class DeviceSettings {
  Future<bool> goToLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  Future<bool> goToAppSettings() async {
    return Geolocator.openAppSettings();
  }
}
