import 'package:sift/sift.dart';

import '../../../../_shared/exceptions/invalid_response_exception.dart';
import '../../../../_shared/exceptions/mapping_exception.dart';
import 'inventory_stock_item.dart';

class InventoryStockReport {
  String _total = "0";
  List<InventoryStockItem> _items = [];

  void updateData(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      _total = sift.readStringFromMap(jsonMap, 'total');
      List<Map<String, dynamic>> itemsMapList = sift.readMapListFromMap(jsonMap, "items");
      _items.addAll(_readItemsFromResponse(itemsMapList));
    } catch (e) {
      throw MappingException('Failed to cast InventoryStockReport response. Error message - ${e.toString()}');
    }
  }

  List<InventoryStockItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var stockItemsList = <InventoryStockItem>[];
      for (var responseMap in responseMapList) {
        var stockItem = InventoryStockItem.fromJson(responseMap);
        stockItemsList.add(stockItem);
      }
      return stockItemsList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  String get total => _total;

  List<InventoryStockItem> get items => _items;
}
