import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item_data.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_tax.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillDetailApprovalItem extends JSONInitializable {
  late String _id;
  late String _billTo;
  late String _billNumber;
  late String _dueDate;
  late String _currency;
  late List<PurchaseBillDetailItemData> _billDetailItemData;

  late String _itemsTotal;
  late String _subTotal;
  late String _grandTotalDiscount;
  late String _total;
  late String _totalTax;

  PurchaseBillDetailApprovalItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "bill_id")}";
      _billTo = sift.readStringFromMap(jsonMap, "bill_to");
      _billNumber = sift.readStringFromMap(jsonMap, "bill_no");
      _dueDate = sift.readStringFromMap(jsonMap, "due_date");
      _currency = sift.readStringFromMap(jsonMap, "currency");

      var billItemMapArray = sift.readMapListFromMap(jsonMap, 'items');
      _billDetailItemData = _getPurchaseBillItemList(billItemMapArray);

      var summaryMap = sift.readMapFromMap(jsonMap, 'summary');
      _itemsTotal = sift.readStringFromMap(summaryMap, 'items_total');
      _subTotal = sift.readStringFromMap(summaryMap, 'sub_total');
      _grandTotalDiscount = sift.readStringFromMap(summaryMap, 'grandtotal_discount');
      _total = sift.readStringFromMap(summaryMap, 'total');

      var taxArray = sift.readMapListFromMap(summaryMap, 'taxes');
      _totalTax = _getTotalTax(taxArray);

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

  String _getTotalTax(List<Map<String, dynamic>> itemMapList) {
    num tax = 0;
    for (var itemMap in itemMapList) {
      var item = PurchaseBillDetailTax.fromJson(itemMap);
      tax += num.parse(item.amount);
    }

    return tax.toString();
  }

  String get billTo => _billTo;

  String get dueDate => _dueDate;

  String get billNumber => _billNumber;

  String get id => _id;

  List<PurchaseBillDetailItemData> get billItemData => _billDetailItemData;

  String get currency => _currency;

  String get itemsTotal => _itemsTotal;

  String get subTotal => _subTotal;

  String get grandTotalDiscount => _grandTotalDiscount;

  String get total => _total;

  String get totalTax => _totalTax;
}
