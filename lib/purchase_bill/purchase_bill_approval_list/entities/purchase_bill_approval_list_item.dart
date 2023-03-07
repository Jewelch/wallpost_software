import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillApprovalBillItem extends JSONInitializable{
  // "bill_id": 5256,
  // "supplier_name": "Alan",
  // "bill_number": "22/00053",
  // "bill_date": "2022-03-25",
  // "due_date": "2022-03-25",
  // "profile_photo": null,
  // "amount": 321,
  // "supplier_id": 257,
  // "decision_status": "pending",
  // "reject_message": null,
  // "payment_status": "Unpaid"

  late String _id;
  late String _supplierId;
  late String _supplierName;
  late String _billNumber;
  late String _billDate;
  late String _dueDate;
  late String _amount;
  late String _decisionStatus;
  late String _paymentStatus;



  PurchaseBillApprovalBillItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "bill_id")}";
      _supplierId = "${sift.readNumberFromMap(jsonMap, "supplier_id")}";
      _supplierName = sift.readStringFromMap(jsonMap, "supplier_name");
      _billNumber = sift.readStringFromMap(jsonMap, "bill_number");
      _billDate = sift.readStringFromMap(jsonMap, "bill_date");
      _dueDate = sift.readStringFromMap(jsonMap, "due_date");
      _dueDate = sift.readStringFromMap(jsonMap, "amount");
      _decisionStatus = sift.readStringFromMap(jsonMap, "decision_status");
      _paymentStatus = sift.readStringFromMap(jsonMap, "payment_status");

    } on SiftException catch (e) {
      throw MappingException('Failed to cast Purchase Bill Approval response. Error message - ${e.errorMessage}');
    }
  }

  String get paymentStatus => _paymentStatus;

  String get decisionStatus => _decisionStatus;

  String get amount => _amount;

  String get dueDate => _dueDate;

  String get billDate => _billDate;

  String get billNumber => _billNumber;

  String get supplierName => _supplierName;

  String get supplierId => _supplierId;

  String get id => _id;
}
