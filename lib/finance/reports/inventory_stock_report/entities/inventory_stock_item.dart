import 'package:sift/Sift.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class InventoryStockItem {
  late final String _name;
  late final String _totalQuantity;
  late final String _totalValue;
  late final String _unit;

  InventoryStockItem.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      _name = sift.readStringFromMap(jsonMap, 'name');
      _totalQuantity = sift.readStringFromMap(jsonMap, 'quantity');
      _totalValue = sift.readStringFromMap(jsonMap, 'total_cost');
      _unit = sift.readStringFromMap(jsonMap, 'unit');
    } catch (e) {
      throw MappingException('Failed to cast InventoryStockItem response. Error message - ${e.toString()}');
    }
  }

  bool isStockNegative() {
    return _totalQuantity.contains("-");
  }

  bool isStockZero() {
    return _totalQuantity == "0";
  }

  String get name => _name;

  String get totalQuantity => _totalQuantity;

  String get totalValue => _totalValue;

  String get unit => _unit;
}
