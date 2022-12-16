import 'dart:async';

import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';

import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/items_sales_urls.dart';

class ItemSalesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  ItemSalesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  ItemSalesProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<ItemSalesDataModel> getItemSales(
      // DateRangeFilters dateRangeFilters
      ) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ItemSalesUrls.getSalesItemUrl(
      "52",
      "0",
      //  dateRangeFilters,
    );
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

  Future<ItemSalesDataModel> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<ItemSalesDataModel>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseList = apiResponse.data as Map<String, dynamic>;
    try {
      return ItemSalesDataModel.fromJson(responseList);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
