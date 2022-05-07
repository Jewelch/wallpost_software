import 'dart:io';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/expense_list/entities/expense_request_status.dart';

class ExpenseRequest extends JSONInitializable {
  late final String id;
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
      requestNo = sift.readStringFromMap(jsonMap, 'expense_request_no').toString();
      var amount = sift.readStringFromMap(jsonMap, 'total_amount');
      totalAmount = Money(double.parse(amount));
      var createdDate = sift.readStringFromMap(jsonMap, 'created_at');
      createdAt = DateTime.parse(createdDate);
      createdBy = sift.readStringFromMap(jsonMap, 'created_by_name');
      var _status = sift.readStringFromMap(jsonMap, 'status');
      status = fromStringToExpenseRequestStatus(_status);
      description = sift.readStringFromMap(jsonMap, 'description');
    } on SiftException catch (e) {
      print(e.errorMessage);
      throw MappingException(
          'Failed to cast ExpenseRequest response. Error message - ${e.errorMessage}');
    }
  }
}
