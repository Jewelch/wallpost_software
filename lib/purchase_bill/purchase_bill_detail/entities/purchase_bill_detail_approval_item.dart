import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item_data.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillDetailApprovalItem extends JSONInitializable{

  late String _id;
  late String _supplierId;
  late String _supplierName;
  late String _billNumber;
  late String _billDate;
  late String _dueDate;
  late String _amount;
  late String _decisionStatus;
  late String _paymentStatus;
  late List<PurchaseBillDetailItemData> _billDetailItemData;

  PurchaseBillDetailApprovalItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "bill_id")}";
      _supplierId = "${sift.readNumberFromMap(jsonMap, "supplier_id")}";
      _supplierName = sift.readStringFromMap(jsonMap, "supplier_name");
      _billNumber = sift.readStringFromMap(jsonMap, "bill_number");
      _billDate = sift.readStringFromMap(jsonMap, "bill_date");
      _dueDate = sift.readStringFromMap(jsonMap, "due_date");
      _amount ="${sift.readStringFromMap(jsonMap, "amount")}";
      _decisionStatus = sift.readStringFromMap(jsonMap, "decision_status");
      _paymentStatus = sift.readStringFromMap(jsonMap, "payment_status");

      var billItemMapArray = sift.readMapListFromMap(jsonMap, 'items');
      _billDetailItemData = _getPurchaseBillItemList(billItemMapArray);

    } on SiftException catch (e) {
      throw MappingException('Failed to cast Purchase Bill Approval response. Error message - ${e.errorMessage}');
    }
  }

  List<PurchaseBillDetailItemData> _getPurchaseBillItemList(List<Map<String, dynamic>> itemMapList) {
    List<PurchaseBillDetailItemData> itemList = [];
    for (var itemMap in itemMapList) {
      var item = PurchaseBillDetailItemData.fromJson(itemMap);
      itemList.add(item);
    }
    return itemList;
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

  List<PurchaseBillDetailItemData> get billItemData => _billDetailItemData;
}
