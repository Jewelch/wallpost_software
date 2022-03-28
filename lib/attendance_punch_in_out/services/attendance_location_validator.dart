import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class AttendanceLocationValidator {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  AttendanceLocationValidator.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  AttendanceLocationValidator()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<bool> validateLocation(AttendanceLocation attendanceLocation, {required bool isForPunchIn}) async {
    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = AttendanceUrls.attendanceLocationValidationUrl(employee.companyId, employee.v1Id, isForPunchIn);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(attendanceLocation.toJson());
    isLoading = true;

    try {
      var _ = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return true;
    } on APIException catch (exception) {
      isLoading = false;

      if (exception is ServerSentException)
        return false;
      else
        throw exception;
    }
  }
}
