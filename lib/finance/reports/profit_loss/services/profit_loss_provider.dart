import 'dart:async';

import '../../../../_shared/date_range_selector/entities/date_range.dart';
import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/profit_loss_urls.dart';
import '../entities/profit_loss_model.dart';

class ProfitsLossesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  ProfitsLossesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  ProfitsLossesProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<ProfitsLossesReport> getProfitsLosses(DateRange dateRange) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ProfitsLossesUrls.getProfitsLossesUrl(companyId, dateRange);
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

  Future<ProfitsLossesReport> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<ProfitsLossesReport>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseList = apiResponse.data as Map<String, dynamic>;
    try {
      return ProfitsLossesReport.fromJson(responseList);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
