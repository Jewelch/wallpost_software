import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';

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
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<void> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<void>().future;

    return null;
  }
}
