import 'dart:async';

import 'package:wallpost/restaurant_and_retail/sales_reports/hourly_sales/entities/hourly_sales_report_filters.dart';

import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/hourly_sales_urls.dart';
import '../entities/hourly_sales_report.dart';

class HourlySalesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  HourlySalesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  HourlySalesProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<HourlySalesReport> getHourlySales(HourlySalesReportFilters filters) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = HourlySalesUrls.getHourSalesUrl(companyId, filters);

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

  Future<HourlySalesReport> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<HourlySalesReport>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    return _readItemsFromResponse(apiResponse.data as Map<String, dynamic>);
  }

  HourlySalesReport _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      final hourlySalesReport = HourlySalesReport.fromJson(responseMap);
      return hourlySalesReport;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
