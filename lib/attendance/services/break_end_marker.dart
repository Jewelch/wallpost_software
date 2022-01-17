import 'dart:async';

import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/constants/attendance_urls.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';

class BreakEndMarker {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  BreakEndMarker.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  BreakEndMarker()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<void> endBreak(AttendanceDetails attendanceDetails, AttendanceLocation location) async {
    if (isLoading) return;
    if (attendanceDetails.activeBreakId == null) return;

    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = AttendanceUrls.breakEndUrl(
        employee.companyId, employee.v1Id, attendanceDetails.attendanceDetailsId!, attendanceDetails.activeBreakId!);
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
