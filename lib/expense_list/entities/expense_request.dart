import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/expense_list/entities/expense_request_status.dart';

class ExpenseRequest extends JSONInitializable {
  late final String id;
  late final String _category;
  late final String _subCategory;
  late final String requestNo;
  late final Money totalAmount;
  late final DateTime createdAt;
  late final String createdBy;
  late final ExpenseRequestStatus status;
  late final String description;

  ExpenseRequest.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      id = sift.readNumberFromMap(jsonMap, 'expense_id').toString();
      _category = sift.readStringFromMap(jsonMap, 'main_category');
      _subCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'sub_category', "")!;
      requestNo = sift.readStringFromMap(jsonMap, 'expense_request_no').toString();
      var amount = sift.readStringFromMap(jsonMap, 'total_amount');
      totalAmount = Money(double.parse(amount));
      createdAt = sift.readDateFromMap(jsonMap, "created_at", "yyyy-MM-dd HH:mm:ss");
      createdBy = sift.readStringFromMap(jsonMap, 'created_by_name');
      var _status = sift.readStringFromMap(jsonMap, 'status');
      status = fromStringToExpenseRequestStatus(_status);
      description = sift.readStringFromMap(jsonMap, 'description');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast ExpenseRequest response. Error message - ${e.errorMessage}');
    }
  }

  String get title => _category + " " + _subCategory;
}
