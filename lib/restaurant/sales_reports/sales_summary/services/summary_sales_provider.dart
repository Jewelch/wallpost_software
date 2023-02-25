import 'dart:async';

import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/sales_summary_urls.dart';
import '../entities/sales_summary_models.dart';
import '../entities/summary_sales_report_filters.dart';

class SummarySalesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  SummarySalesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SummarySalesProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<SalesSummary> getSummarySales(SummarySalesReportFilters filters) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = SummarySalesUrls.getSummarySalesUrl(companyId, filters);

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

  Future<SalesSummary> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<SalesSummary>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    return _readItemsFromResponse(apiResponse.data as Map<String, dynamic>);
  }

  SalesSummary _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      final hourlySalesReport = SalesSummary.fromJson(responseMap);
      return hourlySalesReport;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
