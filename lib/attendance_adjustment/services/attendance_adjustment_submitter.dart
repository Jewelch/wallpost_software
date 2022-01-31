import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';

class AttendanceAdjustmentSubmitter {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentSubmitter.initWith(
      this._selectedEmployeeProvider, this._networkAdapter);

  AttendanceAdjustmentSubmitter()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<void> submitAdjustment(
      AttendanceAdjustmentForm attendanceAdjustmentForm) async {
    if (isLoading) return;

    var employee =
        _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = AttendanceAdjustmentUrls.submitAdjustmentUrl(
        employee.companyId,
        employee.v1Id);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(attendanceAdjustmentForm.toJson());
    // apiRequest.addParameters({
    //   'id':null,
    //   'attendance_id':'abc',
    //   'work_status': 'absent',
    //   'punch_in_time': '',
    //   'punch_out_time': '',
    //   'approval_status': 'null',
    //   'edit_mode': false,
    //   'orig_punch_in_time': null,
    //   'orig_punch_out_time': null,
    //   'punch_in_time_error': false,
    //   'punch_out_time_error': false,
    //   'status_out_error': false,
    //   'approver_name': null,
    //   'attnce_reason_error': false,
    //   'employee_id': employee.v1Id,
    //   'company_id': employee.companyId,
    //   'adjusted_status': 'present',
    //  } );
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
