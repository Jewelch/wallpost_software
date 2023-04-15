import 'dart:async';

import '../../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/inventory_stock_report_urls.dart';
import '../entities/inventory_stock_warehouse.dart';

class InventoryWarehouseListProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool isLoading = false;

  InventoryWarehouseListProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  InventoryWarehouseListProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<List<InventoryStockWarehouse>> getAll() async {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    var url = InventoryStockReportUrls.inventoryWarehouseUrl(company.id);
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

  Future<List<InventoryStockWarehouse>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<InventoryStockWarehouse>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<InventoryStockWarehouse> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var warehouseList = <InventoryStockWarehouse>[];
      for (var responseMap in responseMapList) {
        var warehouse = InventoryStockWarehouse.fromJson(responseMap);
        warehouseList.add(warehouse);
      }
      return warehouseList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
