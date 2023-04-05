import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillApprovalListItem extends JSONInitializable{

  late String _id;
  late String _companyId;
  late String? _supplierName;
  late String _billNumber;
  late String _billDate;
  late String _dueDate;
  late String _amount;
  late String? _currency;
  late String _decisionStatus;
  late String _paymentStatus;

  PurchaseBillApprovalListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "bill_id")}";
      _companyId="${sift.readNumberFromMap(jsonMap, "company_id")}";
      _supplierName = sift.readStringFromMapWithDefaultValue(jsonMap, "supplier_name","");
      _billNumber = sift.readStringFromMap(jsonMap, "bill_number");
      _billDate = sift.readStringFromMap(jsonMap, "bill_date");
      _dueDate = sift.readStringFromMap(jsonMap, "due_date");
      _amount ="${sift.readNumberFromMap(jsonMap, "amount")}";
      _currency = sift.readStringFromMapWithDefaultValue(jsonMap, "currency","");
      _decisionStatus = sift.readStringFromMap(jsonMap, "decision_status");
      _paymentStatus = sift.readStringFromMap(jsonMap, "payment_status");

    } on SiftException catch (e) {
      throw MappingException('Failed to cast Purchase Bill Approval response. Error message - ${e.errorMessage}');
    }
  }

  String get id => _id;

  String get companyId => _companyId;

  String? get supplierName => _supplierName;

  String get billNumber => _billNumber;

  String get dueDate => _dueDate;

  String get billDate => _billDate;

  String get amount => _amount;

  String? get currency => _currency;

  String get paymentStatus => _paymentStatus;

  String get decisionStatus => _decisionStatus;

}
