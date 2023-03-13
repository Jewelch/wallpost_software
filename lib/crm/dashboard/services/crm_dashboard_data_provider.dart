import 'dart:async';

import 'package:wallpost/crm/dashboard/constants/crm_dashboard_urls.dart';
import 'package:wallpost/crm/dashboard/entities/crm_dashboard_data.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../_wp_core/wpapi/services/wp_api.dart';

class CrmDashboardDataProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  CrmDashboardDataProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  CrmDashboardDataProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<CrmDashboardData> get({required int month, required int year}) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = CrmDashboardUrls.getDashboardDataUrl(companyId, month, year);
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

  Future<CrmDashboardData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<CrmDashboardData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();

    //Returning empty data if response type is a list
    if (apiResponse.data is List<Map<String, dynamic>>) return CrmDashboardData.fromJson({});

    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return CrmDashboardData.fromJson(responseMap);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
