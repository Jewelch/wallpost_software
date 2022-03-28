import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class PunchInMarker {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PunchInMarker.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  PunchInMarker()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<void> punchIn(AttendanceLocation location, {required bool isLocationValid}) async {
    if (isLoading) return;

    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = AttendanceUrls.punchInUrl(employee.companyId, employee.v1Id, isLocationValid);
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
