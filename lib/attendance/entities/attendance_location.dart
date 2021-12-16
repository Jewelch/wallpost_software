// @dart=2.9

import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class AttendanceLocation implements JSONConvertible {
  final num latitude;
  final num longitude;

  AttendanceLocation(
    this.latitude,
    this.longitude,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'locationInfo': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}
