import 'dart:async';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/manager_my_portal_dashboard_urls.dart';
import '../entities/hr_dashboard_data.dart';

class HRDashboardDataProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  HRDashboardDataProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  HRDashboardDataProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<HRDashboardData> get({int? month, int? year}) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ManagerMyPortalDashboardUrls.hrDataUrl(companyId, month == 0 ? null : month, year);
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

  Future<HRDashboardData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<HRDashboardData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return HRDashboardData.fromJson(responseMap);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
