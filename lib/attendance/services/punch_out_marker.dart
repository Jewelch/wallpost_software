import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/constants/attendance_urls.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class PunchOutMarker {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PunchOutMarker.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  PunchOutMarker()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<void> punchOut(
    AttendanceDetails attendanceDetails,
    AttendanceLocation location, {
    required bool isLocationValid,
  }) async {
    if (isLoading) return;

    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url =
        AttendanceUrls.punchOutUrl(employee.companyId, employee.v1Id, attendanceDetails.attendanceId!, isLocationValid);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(location.toJson());
    isLoading = true;

    try {
      var _ = await _networkAdapter.put(apiRequest);
      isLoading = false;
      return;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}
