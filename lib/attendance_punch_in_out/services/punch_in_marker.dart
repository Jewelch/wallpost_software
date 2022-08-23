import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';

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
}
