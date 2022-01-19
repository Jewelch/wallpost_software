import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position> getLocation() async {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
  }

  Future<String?> getLocationAddress(Position position) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = p[0];
      return "${place.street}";
    } catch (e) {
      print(e);
      return null;
    }
  }
}
// 1. Getting the location - attendance will not work wihtout this - use get location
//     2. getlocationaddress - optional
