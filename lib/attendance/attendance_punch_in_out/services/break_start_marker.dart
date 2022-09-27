import 'dart:async';

import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/break.dart';

class BreakStartMarker {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  BreakStartMarker.initWith(this._networkAdapter);

  BreakStartMarker() : _networkAdapter = WPAPI();

  Future<List<Break>> startBreak(AttendanceDetails attendanceDetails, AttendanceLocation location) async {
    var url = AttendanceUrls.breakStartUrl(attendanceDetails.attendanceDetailsId!);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(location.toJson());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      //await _networkAdapter.post(apiRequest);
      isLoading = false;
      //return null;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<List<Break>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<Break>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return _readItemsFromResponse(responseMap);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  List<Break> _readItemsFromResponse(Map<String, dynamic> responseMap) {
    List<Break> attendanceListItems = [];
    var sift = Sift();
    var dataMap = sift.readMapListFromMap(responseMap, "data");
    for (var attendanceJson in dataMap) {
      var listItem = Break.fromJson(attendanceJson);
      attendanceListItems.add(listItem);
    }
    return attendanceListItems;
  }
  // Future<Break> _processResponse(APIResponse apiResponse) async {
  //   if (apiResponse.data == null) throw InvalidResponseException();
  //   if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();
  //
  //   var responseMap = apiResponse.data as Map<String, dynamic>;
  //   try {
  //     var user = Break.fromJson(responseMap);
  //
  //     return user;
  //   } catch (e) {
  //     throw InvalidResponseException();
  //   }
  // }

}
