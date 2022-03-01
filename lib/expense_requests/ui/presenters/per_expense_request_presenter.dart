import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/entities/identifier.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/per_expense_request_view.dart';

class PerExpenseRequestPresenter {
  PerExpenseRequestView _view;

  ExpenseCategory? parentCategory;
  ExpenseCategory? category;
  Identifier? project;
  String? _date;
  String description = "";
  int _quantity = 1;
  int _rate = 0;
  int _amount = 1;
  int _total = 1;

  PerExpenseRequestPresenter(this._view);

  ExpenseRequestForm? getExpenseRequest() {
    if (parentCategory == null) {
      _view.notifyMissingParentCategory("Missing Category Value");
    } else if (category == null) {
      _view.notifyMissingChildCategory("Missing SubCategory Value");
    } else if (_date == null) {
      _view.notifyMissingDate("Missing Date Value");
    } else {
      return ExpenseRequestForm(
        parentCategory: parentCategory!.id,
        category: category!.id,
        date: date,
        description: description,
        quantity: quantity,
        rate: rate,
        amount: amount,
        files: [],
        total: total,
      );
    }
  }

  // Setters

  void setDate(DateTime dateTime) {
    this._date = dateTime.toIso8601String();
  }

  void setQuantity(String quantity) {
    _quantity = int.tryParse(quantity) ?? 1;
  }

  void setRate(String rate) {
    _rate = int.tryParse(rate) ?? 0;
  }

  void setAmount(String amount) {
    _amount = int.tryParse(amount) ?? 1;
  }

  void setTotal(String total) {
    _total = int.tryParse(total) ?? 1;
  }

  // Getters

  String get date => _date ?? "";

  String get quantity => _quantity.toString();

  String get rate => _rate.toString();

  String get amount => _amount.toString();

  String get total => _total.toString();
}
