import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../constants/payables_and_ageing​_urls.dart';
import '../entities/payables_and_ageing_data.dart';

class PayablesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  PayablesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  PayablesProvider.initWith(
    this._networkAdapter,
    this._selectedCompanyProvider,
  );

  Future<PayablesData> getPayables() async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = PayablesUrls.getUrl(companyId);
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

  Future<PayablesData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<PayablesData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return PayablesData.fromJson(responseMap);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
