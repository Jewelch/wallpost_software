import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';

class BreakEndMarker {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  BreakEndMarker.initWith(this._networkAdapter);

  BreakEndMarker() : _networkAdapter = WPAPI();

  Future<void> endBreak(AttendanceDetails attendanceDetails, AttendanceLocation location) async {
    if (attendanceDetails.activeBreakId == null) return;

    var url = AttendanceUrls.breakEndUrl(attendanceDetails.attendanceDetailsId!,attendanceDetails.activeBreakId!);
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
