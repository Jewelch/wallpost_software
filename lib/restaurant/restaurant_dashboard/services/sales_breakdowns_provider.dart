import 'dart:async';

import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/constants/restaurant_dashboard_urls.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';


class SalesBreakDownsProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  SalesBreakDownsProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SalesBreakDownsProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<List<SalesBreakDownItem>> getSalesBreakDowns(
      SalesBreakDownWiseOptions salesBreakDownWiseOption, DateRange dateRangeFilters) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl(companyId, salesBreakDownWiseOption, dateRangeFilters);
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
