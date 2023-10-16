import 'dart:async';

import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';

import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/orders_summary_urls.dart';
import '../entities/orders_summary.dart';

class OrdersSummaryProvider {
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;
  final SelectedCompanyProvider _selectedCompanyProvider;

  OrdersSummaryProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  OrdersSummaryProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<OrdersSummary> getNext(DateRange dateRange) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = OrdersSummaryUrls.ordersSummaryList(companyId, dateRange, _pageNumber, _perPage);
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<OrdersSummary> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<OrdersSummary>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    print(apiResponse.data);
    if (apiResponse.data is! Map<String, dynamic> || apiResponse.data['orders'] is! List)
      throw InvalidResponseException();

    var responseMap = apiResponse.data;
    return _readItemsFromResponse(responseMap);
  }

  OrdersSummary _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      var ordersSummary = OrdersSummary.fromJson(responseMap);
      _updatePaginationRelatedData(ordersSummary.orders.length);
      return ordersSummary;
    } catch (_) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }

  bool get didReachListEnd => _didReachListEnd;
}
