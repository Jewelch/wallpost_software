import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';

class AdjustedStatusProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool isLoading = false;

  AdjustedStatusProvider.initWith(
      this._selectedEmployeeProvider, this._networkAdapter);

  AdjustedStatusProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<AttendanceStatus> getAdjustedStatus(
      AdjustedStatusForm adjustedStatusForm) async {
    var employee =
        _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();

    var url = AttendanceAdjustmentUrls.getAdjustedStatusUrl(
        employee.companyId,
        employee.v1Id,
        adjustedStatusForm.date,
        adjustedStatusForm.adjustedPunchInTime,
        adjustedStatusForm.adjustedPunchOutTime);
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
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<AttendanceStatus>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! String) throw WrongResponseFormatException();

    var adjustedStatusString = apiResponse.data as String;
    var adjustedStatus =
        initializeAttendanceStatusFromString(adjustedStatusString);

    if (adjustedStatus != null) {
      return adjustedStatus;
    } else {
      throw InvalidResponseException();
    }
  }
}
