import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';

class PunchOutMarker {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PunchOutMarker.initWith(this._networkAdapter);

  PunchOutMarker() : _networkAdapter = WPAPI();

  Future<void> punchOut(AttendanceDetails attendanceDetails, AttendanceLocation location,
      {required bool isLocationValid}) async {
    var url = AttendanceUrls.punchOutUrl(attendanceDetails.attendanceId!, isLocationValid);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(location.toJson());
    isLoading = true;

    try {
      await _networkAdapter.put(apiRequest);
      isLoading = false;
      return null;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}
