import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_data.dart';

import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../constants/restaurant_dashboard_urls.dart';

class SalesDataProvider {
  SalesDataProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SalesDataProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  final NetworkAdapter _networkAdapter;
  SelectedCompanyProvider _selectedCompanyProvider;

  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  Future<SalesData> getSalesAmounts({String? storeId}) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = RestaurantDashboardUrls.getSalesAmountsUrl(companyId, storeId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
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

  Future<SalesData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<SalesData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    return _readItemsFromResponse(responseMap);
  }

  SalesData _readItemsFromResponse(Map<String, dynamic> responseMap) {
    try {
      return SalesData.fromJson(responseMap['data']);
    } catch (_) {
      throw InvalidResponseException();
    }
  }
}
