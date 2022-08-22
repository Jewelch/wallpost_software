import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';

class AttendanceAdjustmentSubmitter {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentSubmitter.initWith(this._selectedCompanyProvider, this._networkAdapter);

  AttendanceAdjustmentSubmitter()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<void> submitAdjustment(AttendanceAdjustmentForm attendanceAdjustmentForm) async {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    var employee = company.employee;
    var url = AttendanceAdjustmentUrls.submitAdjustmentUrl(company.id, employee.v1Id);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(attendanceAdjustmentForm.toJson());

    _isLoading = true;
    try {
      var _ = await _networkAdapter.post(apiRequest);
      _isLoading = false;
      return;
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  bool get isLoading => _isLoading;
}
