import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillDetailItem extends JSONInitializable {
  late String _itemName;
  late String _quantity;
  late String _rate;
  late String _total;
  late String _description;


  PurchaseBillDetailItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _itemName = sift.readStringFromMap(jsonMap, "item_name");
      _quantity = sift.readStringFromMap(jsonMap, "quantity");
      _rate = "${sift.readNumberFromMap(jsonMap, "price")}";
      _total = sift.readStringFromMap(jsonMap, "amount");
      _description=sift.readStringFromMapWithDefaultValue(jsonMap, 'description')!;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast purchase bill response. Error message - ${e.errorMessage}');
    }
  }

  String get total => _total;

  String get rate => _rate;

  String get quantity => _quantity;

  String get itemName => _itemName;

  String get description => _description;

}
