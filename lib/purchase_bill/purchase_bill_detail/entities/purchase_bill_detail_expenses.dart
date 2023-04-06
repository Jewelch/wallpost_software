import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillDetailExpenses extends JSONInitializable {
  late String _expenseName;
  late String _description;
  late String _amount;

  PurchaseBillDetailExpenses.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _expenseName = sift.readStringFromMap(jsonMap, "expense_name");
      _description = sift.readStringFromMap(jsonMap, "description");
      _amount = sift.readStringFromMap(jsonMap, "amount");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast bill detail expenses response. Error message - ${e.errorMessage}');
    }
  }

  String get expenseName => _expenseName;

  String get amount => _amount;

  String get description => _description;


}
