import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../attendance__core/entities/attendance_status.dart';
import '../constants/attendance_adjustment_urls.dart';
import '../entities/adjusted_status_form.dart';

class AdjustedStatusProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool _isLoading = false;

  AdjustedStatusProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  AdjustedStatusProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<AttendanceStatus> getAdjustedStatus(AdjustedStatusForm adjustedStatusForm) async {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    var employee = company.employee;
    var url = AttendanceAdjustmentUrls.getAdjustedStatusUrl(
      company.id,
      employee.v1Id,
      adjustedStatusForm.date,
      adjustedStatusForm.adjustedPunchInTime,
      adjustedStatusForm.adjustedPunchOutTime,
    );
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    _isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  Future<AttendanceStatus> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<AttendanceStatus>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! String) throw WrongResponseFormatException();

    var adjustedStatusString = apiResponse.data as String;
    var adjustedStatus = AttendanceStatus.initFromString(adjustedStatusString);

    if (adjustedStatus != null) {
      return adjustedStatus;
    } else {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
