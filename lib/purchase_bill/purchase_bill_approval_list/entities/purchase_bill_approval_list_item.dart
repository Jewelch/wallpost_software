import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillApprovalListItem extends JSONInitializable{

  late String _id;
  late String _companyId;
  late String? _supplierName;
  late String _billNumber;
  late DateTime _billDate;
  late DateTime _dueDate;
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
      _billDate = sift.readDateFromMap(jsonMap, "bill_date", "yyyy-MM-dd");
      _dueDate = sift.readDateFromMap(jsonMap, "due_date", "yyyy-MM-dd");
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

  DateTime get dueDate => _dueDate;

  DateTime get billDate => _billDate;

  String get amount => _amount;

  String? get currency => _currency;

  String get paymentStatus => _paymentStatus;

  String get decisionStatus => _decisionStatus;

}
