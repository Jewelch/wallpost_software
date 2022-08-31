import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_report.dart';

class AttendanceReportProvider {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  AttendanceReportProvider.initWith(this._networkAdapter);

  AttendanceReportProvider() : _networkAdapter = WPAPI();

  Future<AttendanceReport> getReport() async {
    var startDate = _getFirstDayOfCurrentMonth().yyyyMMddString();
    var endDate = _getLastDayOfCurrentMonth().yyyyMMddString();

    var url = AttendanceUrls.attendanceReportUrl(startDate, endDate);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    _isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  DateTime _getFirstDayOfCurrentMonth() {
    var date = DateTime.now();
    var firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    return firstDayOfTheMonth;
  }

  DateTime _getLastDayOfCurrentMonth() {
    var date = DateTime.now();
    var lastDayOfTheMonth = DateTime(date.year, date.month + 1, 0);
    return lastDayOfTheMonth;
  }

  Future<AttendanceReport> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<AttendanceReport>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as List<Map<String, dynamic>>;
    try {
      var attendanceReport = AttendanceReport.fromJson(responseMap);
      return attendanceReport;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
