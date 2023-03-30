import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillDetailTax extends JSONInitializable {
  late String _amount;
  late String _type;

  PurchaseBillDetailTax.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _amount = "${sift.readNumberFromMap(jsonMap, "amount")}";
      _type = sift.readStringFromMap(jsonMap, "type");

    } on SiftException catch (e) {
      throw MappingException('Failed to cast purchase bill approval response. Error message - ${e.errorMessage}');
    }
  }

  String get type => _type;

  String get amount => _amount;
}
