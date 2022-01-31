import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';

class AttendanceAdjustmentSubmitter {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentSubmitter.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  AttendanceAdjustmentSubmitter()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  Future<void> submitAdjustment(List<AttendanceAdjustmentForm> attendanceAdjustmentForms) async {
    if (isLoading) return;

    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = AttendanceAdjustmentUrls.submitAdjustmentUrl(employee.companyId, employee.v1Id);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("adjustments", _generatePayload(attendanceAdjustmentForms));

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

  List<Map<String, dynamic>> _generatePayload(List<AttendanceAdjustmentForm> attendanceAdjustmentForms) {
    List<Map<String, dynamic>> payload = [];
    for (AttendanceAdjustmentForm form in attendanceAdjustmentForms) {
      payload.add(form.toJson());
    }
    return payload;
  }
}
