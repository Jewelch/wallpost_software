import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_details.dart';

class AttendanceDetailsProvider {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  AttendanceDetailsProvider.initWith(this._networkAdapter);

  AttendanceDetailsProvider() : _networkAdapter = WPAPI();

  Future<AttendanceDetails> getDetails() async {
    var url = AttendanceUrls.getAttendanceDetailsUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<AttendanceDetails> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<AttendanceDetails>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var attendanceDetails = AttendanceDetails.fromJson(responseMap);
      return attendanceDetails;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
