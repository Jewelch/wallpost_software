import 'package:sift/sift.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class InventoryStockWarehouse {
  late final String _id;
  late final String _name;

  InventoryStockWarehouse.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, 'id')}";
      _name = sift.readStringFromMap(jsonMap, 'name');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast InventoryStockWarehouse response. Error message - ${e.errorMessage}');
    }
  }

  String get id => _id;

  String get name => _name;
}
