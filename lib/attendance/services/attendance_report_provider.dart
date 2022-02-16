import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/constants/attendance_urls.dart';
import 'package:wallpost/attendance/entities/attendance_report.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class AttendanceReportProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  AttendanceReportProvider.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  AttendanceReportProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<AttendanceReport> getReport() async {
    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var companyId = employee.companyId;
    var employeeId = employee.v1Id;
    var startDate = _getFirstDayOfCurrentMonth().yyyyMMddString();
    var endDate = _getLastDayOfCurrentMonth().yyyyMMddString();

    var url = AttendanceUrls.attendanceReportUrl(companyId, employeeId, startDate, endDate);
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
}
