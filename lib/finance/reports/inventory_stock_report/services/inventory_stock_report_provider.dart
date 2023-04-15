import 'dart:async';

import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/inventory_stock_report_urls.dart';
import '../entities/inventory_stock_report.dart';
import '../entities/inventory_stock_report_filter.dart';

class InventoryStockReportProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;
  InventoryStockReport _report = InventoryStockReport();

  InventoryStockReportProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  InventoryStockReportProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _report = InventoryStockReport();
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<InventoryStockReport> getNext(InventoryStockReportFilter filters) async {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    var url = InventoryStockReportUrls.inventoryStockReportUrl(
      companyId: company.id,
      date: filters.date,
      warehouse: filters.warehouse,
      searchText: filters.searchText,
      pageNumber: _pageNumber,
      itemsPerPage: _perPage,
    );
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

  Future<InventoryStockReport> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<InventoryStockReport>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      int currentItemCount = _report.items.length;
      _report.updateData(responseMap);
      int numberOfItemsReceived = _report.items.length - currentItemCount;
      _updatePaginationRelatedData(numberOfItemsReceived);
      return _report;
    } catch (e) {
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
