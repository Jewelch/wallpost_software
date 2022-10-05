import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';

class BreakStartMarker {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  BreakStartMarker.initWith(this._networkAdapter);

  BreakStartMarker() : _networkAdapter = WPAPI();

  Future<void> startBreak(AttendanceDetails attendanceDetails, AttendanceLocation location) async {
    var url = AttendanceUrls.breakStartUrl(attendanceDetails.attendanceDetailsId!);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(location.toJson());
    isLoading = true;

    try {
      await _networkAdapter.post(apiRequest);
      isLoading = false;
      return null;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}
