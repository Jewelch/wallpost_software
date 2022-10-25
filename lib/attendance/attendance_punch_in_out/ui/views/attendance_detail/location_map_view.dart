import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';

class LocationMapView extends StatelessWidget {
  final AttendanceLocation attendanceLocation;

  LocationMapView({
    required this.attendanceLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(28), bottomRight: Radius.circular(28)),
      child: GoogleMap(
        zoomControlsEnabled: false,
        compassEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        myLocationButtonEnabled: false,
        scrollGesturesEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(attendanceLocation.latitude.toDouble(), attendanceLocation.longitude.toDouble()),
          zoom: 16.0,
        ),
        markers: Set<Marker>()
          ..add(Marker(
            markerId: MarkerId('Current Location'),
            position: LatLng(attendanceLocation.latitude.toDouble(), attendanceLocation.longitude.toDouble()),
          )),
      ),
    );
  }
}
