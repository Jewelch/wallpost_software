import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';

class PunchInMarker {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PunchInMarker.initWith(this._networkAdapter);

  PunchInMarker() : _networkAdapter = WPAPI();

  Future<void> punchIn(AttendanceLocation location, {required bool isLocationValid}) async {
    var url = AttendanceUrls.punchInUrl(isLocationValid);
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

  // Future<String?> _processResponse(APIResponse apiResponse) async {
  //   //returning if the response is from another session
  //   if (apiResponse.apiRequest.requestId != _sessionId) return Completer<String?>().future;
  //   if (apiResponse.data == null) throw InvalidResponseException();
  //   if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();
  //
  //   var responseMap = apiResponse.data as Map<String, dynamic>;
  //   var sift = Sift();
  //   try {
  //     var attendanceDetailsList = sift.readMapListFromMapWithDefaultValue(responseMap, 'attendance_details');
  //     var attendanceDetailsMap = sift.readMapFromListWithDefaultValue(attendanceDetailsList, 0, null);
  //     var punchInTime = sift.readStringFromMap(attendanceDetailsMap, 'punch_in');
  //     return punchInTime;
  //   } catch (e) {
  //     throw InvalidResponseException();
  //   }
  // }
}
