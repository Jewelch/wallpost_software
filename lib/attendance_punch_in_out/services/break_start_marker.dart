import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class BreakStartMarker {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  BreakStartMarker.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  BreakStartMarker()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<void> startBreak(AttendanceDetails attendanceDetails, AttendanceLocation location) async {
    if (isLoading) return;

    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = AttendanceUrls.breakStartUrl(employee.companyId, employee.v1Id, attendanceDetails.attendanceDetailsId!);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(location.toJson());
    isLoading = true;

    try {
      var _ = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}
