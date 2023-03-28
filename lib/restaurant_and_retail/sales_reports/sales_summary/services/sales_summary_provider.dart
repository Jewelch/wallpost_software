import 'dart:async';

import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';

import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/sales_summary_urls.dart';
import '../entities/sales_summary.dart';

class SalesSummaryProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  SalesSummaryProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SalesSummaryProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<SalesSummary> getSummarySales(DateRange dateRange) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = SummarySalesUrls.getSummarySalesUrl(companyId, dateRange);

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
      final salesSummaryReport = SalesSummary.fromJson(responseMap);
      return salesSummaryReport;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
