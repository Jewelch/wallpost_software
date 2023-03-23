import 'dart:async';

import '../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/dashboard_urls.dart';
import '../entities/sales_break_down_item.dart';
import '../entities/sales_break_down_wise_options.dart';
import '../ui/views/screens/dashboard_screen.dart';

class SalesBreakDownsProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  final DashboardContext dashboardContext;

  SalesBreakDownsProvider({required this.dashboardContext})
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SalesBreakDownsProvider.initWith(
    this._networkAdapter,
    this._selectedCompanyProvider,
    this.dashboardContext,
  );

  Future<List<SalesBreakDownItem>> getSalesBreakDowns(
      SalesBreakDownWiseOptions salesBreakDownWiseOption, DateRangeFilters dateRangeFilters) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url =
        DashboardUrls.getSalesBreakDownsUrl(companyId, salesBreakDownWiseOption, dateRangeFilters, dashboardContext);
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

  Future<List<SalesBreakDownItem>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<SalesBreakDownItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseList = apiResponse.data as List<Map<String, dynamic>>;
    var salesBreakDowns = <SalesBreakDownItem>[];
    try {
      responseList.forEach((element) {
        salesBreakDowns.add(SalesBreakDownItem.fromJson(element));
      });
      return salesBreakDowns;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
