import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class AdjustedAttendanceStatusProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool isLoading = false;

  AdjustedAttendanceStatusProvider.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  AdjustedAttendanceStatusProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<AttendanceStatus> getAdjustedStatus(AttendanceAdjustmentForm attendanceAdjustmentForm) async {
    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();

    var url = AttendanceAdjustmentUrls.getAdjustedStatusUrl(
        employee.companyId,
        employee.v1Id,
        attendanceAdjustmentForm.date,
        attendanceAdjustmentForm.adjustedPunchInTime!,
        attendanceAdjustmentForm.adjustedPunchOutTime!);
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

  Future<AttendanceStatus> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<AttendanceStatus>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! String) throw WrongResponseFormatException();

    var adjustedStatusString = apiResponse.data as String;
    var adjustedStatus = initializeAttendanceStatusFromString(adjustedStatusString);

    if (adjustedStatus != null) {
      return adjustedStatus;
    } else {
      throw InvalidResponseException();
    }
  }
}
