import 'dart:async';

import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../../../../_wp_core/wpapi/services/wp_api.dart';
import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../constants/stock_expiration_urls.dart';
import '../entities/stock_expiration.dart';

class StocksExpirationProvider {
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;
  final SelectedCompanyProvider _selectedCompanyProvider;

  StocksExpirationProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  StocksExpirationProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<StockExpiration>> getNext(bool expired, int days) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = expired
        ? StocksExpirationUrls.getExpiredUrl(companyId, _pageNumber, _perPage)
        : StocksExpirationUrls.getExpiredInDaysUrl(companyId, days, _pageNumber, _perPage);
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

  Future<List<StockExpiration>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<StockExpiration>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data;
    return _readItemsFromResponse(responseMap);
  }

  List<StockExpiration> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var stocksExpiration = <StockExpiration>[];
      for (var responseMap in responseMapList) {
        var item = StockExpiration.fromJson(responseMap);
        stocksExpiration.add(item);
      }
      _updatePaginationRelatedData(stocksExpiration.length);
      return stocksExpiration;
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
