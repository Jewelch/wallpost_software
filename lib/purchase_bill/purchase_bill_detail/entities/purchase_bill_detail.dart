import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_expenses.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_tax.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class PurchaseBillDetail extends JSONInitializable {
  late String _id;
  late String _billTo;
  late String _billNumber;
  late DateTime _dueDate;
  late String _currency;
  late List<PurchaseBillDetailItem> _billDetailItem;
  late List<PurchaseBillDetailExpenses> _billDetailExpensesItem;
  late String _itemsTotal;
  late String _subTotal;
  late String _expenseTotal;
  late String _totalDiscount;
  late String _total;
  late String _totalTax;

  PurchaseBillDetail.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "bill_id")}";
      _billTo = sift.readStringFromMap(jsonMap, "bill_to");
      _billNumber = sift.readStringFromMap(jsonMap, "bill_no");
      _dueDate = sift.readDateFromMap(jsonMap, "due_date", "yyyy-MM-dd");
      _currency = sift.readStringFromMap(jsonMap, "currency");

      var billItemMapArray = sift.readMapListFromMap(jsonMap, 'items');
      _billDetailItem = _getPurchaseBillItemList(billItemMapArray);

      var billExpensesItemMapArray = sift.readMapListFromMap(jsonMap, 'expenses');
      _billDetailExpensesItem = _getPurchaseBillExpensesList(billExpensesItemMapArray);

      var summaryMap = sift.readMapFromMap(jsonMap, 'summary');
      _itemsTotal = sift.readStringFromMap(summaryMap, 'items_total');
      _subTotal = sift.readStringFromMap(summaryMap, 'sub_total');
      _expenseTotal = sift.readStringFromMap(summaryMap, 'expenses_total');
      _totalDiscount = sift.readStringFromMap(summaryMap, 'total_discount');
      _total = sift.readStringFromMap(summaryMap, 'total');
      var taxArray = sift.readMapListFromMap(summaryMap, 'taxes');
      _totalTax = _getTotalTax(taxArray);

    } on SiftException catch (e) {
      throw MappingException('Failed to cast purchase bill detail response. Error message - ${e.errorMessage}');
    }
  }

  List<PurchaseBillDetailItem> _getPurchaseBillItemList(List<Map<String, dynamic>> itemMapList) {
    List<PurchaseBillDetailItem> itemList = [];
    for (var itemMap in itemMapList) {
      var item = PurchaseBillDetailItem.fromJson(itemMap);
      itemList.add(item);
    }
    return itemList;
  }

  List<PurchaseBillDetailExpenses> _getPurchaseBillExpensesList(List<Map<String, dynamic>> itemMapList) {
    List<PurchaseBillDetailExpenses> expensesList = [];
    for (var itemMap in itemMapList) {
      var item = PurchaseBillDetailExpenses.fromJson(itemMap);
      expensesList.add(item);
    }
    return expensesList;
  }

  String _getTotalTax(List<Map<String, dynamic>> itemMapList) {
    num tax = 0;
    for (var itemMap in itemMapList) {
      var item = PurchaseBillDetailTax.fromJson(itemMap);
      tax += num.parse(item.amount);
    }

    return tax.toString();
  }

  String get id => _id;

  String get billTo => _billTo;

  String get billNumber => _billNumber;

  DateTime get dueDate => _dueDate;

  String get currency => _currency;

  List<PurchaseBillDetailItem> get billDetailItem => _billDetailItem;

  List<PurchaseBillDetailExpenses> get billDetailExpenseItem => _billDetailExpensesItem;

  String get itemsTotal => _itemsTotal;

  String get expenseTotal => _expenseTotal;

  String get subTotal => _subTotal;

  String get totalDiscount => _totalDiscount;

  String get total => _total;

  String get totalTax => _totalTax;
}
