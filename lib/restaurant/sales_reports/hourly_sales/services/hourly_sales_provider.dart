import 'dart:async';

import '../../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/items_sales_urls.dart';
import '../entities/houlry_sales_model.dart';

class HourlySalesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  HourlySalesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  HourlySalesProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _isLoading = false;
  }

  Future<HourlySalesReport> getHourlySales(DateRangeFilters dateRangeFilters) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = HourlySalesUrls.getSalesItemUrl(companyId, dateRangeFilters, _pageNumber, _perPage, true);

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
      final Map<String, dynamic> response = {
        "summary": {
          "total_tickets": "10,000",
          "tickets": "5,990",
        },
        "data": [
          {
            "hour": "9 to 10 AM",
            "tickets": "8",
            "ticket_total": "2,550",
          },
          {
            "hour": "11 AM to 12 PM",
            "tickets": "18",
            "ticket_total": "3,000",
          },
          {
            "hour": "12 to 1 PM",
            "tickets": "3",
            "ticket_total": "750",
          },
          {
            "hour": "1 to 2 PM",
            "tickets": "2",
            "ticket_total": "1,050",
          },
        ]
      };

      final hourlySalesReport = HourlySalesReport.fromJson(response);
      _updatePaginationRelatedData(hourlySalesReport.hourlySales.length);
      return hourlySalesReport;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) _pageNumber += 1;
    if (noOfItemsReceived < _perPage) _didReachListEnd = true;
  }

  int getCurrentPageNumber() => _pageNumber;

  bool get didReachListEnd => _didReachListEnd;
}
