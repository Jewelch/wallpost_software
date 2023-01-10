import 'dart:async';

import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/manager_my_portal_dashboard_urls.dart';
import '../entities/manager_my_portal_data.dart';

class ManagerMyPortalDataProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  ManagerMyPortalDataProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  ManagerMyPortalDataProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<ManagerMyPortalData> get({int? month, int? year}) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ManagerMyPortalDashboardUrls.managerMyPortalDataUrl(companyId, month == 0 ? null : month, year);
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

  Future<ManagerMyPortalData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<ManagerMyPortalData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var currency = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
      return ManagerMyPortalData.fromJson(responseMap, currency);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
