import 'dart:async';

import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/finance_dashboard_urls.dart';
import '../entities/finance_dashboard_data.dart';

class FinanceDashBoardProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  FinanceDashBoardProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  FinanceDashBoardProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<FinanceDashBoardData> get({int? year, int? month}) async {
    var companyId ='28';
    //var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = FinanceDashBoardUrls.getFinanceInnerPageDetails(companyId, year, month);
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

  Future<FinanceDashBoardData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<FinanceDashBoardData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return FinanceDashBoardData.fromJson(responseMap);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
