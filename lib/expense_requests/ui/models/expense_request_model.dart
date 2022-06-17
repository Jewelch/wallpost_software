import 'dart:io';

import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';

class ExpenseRequestModel {
  ExpenseCategory? selectedMainCategory;
  ExpenseCategory? selectedSubCategory;
  ExpenseCategory? selectedProject;
  DateTime date = DateTime.now();
  String description = "";
  int _quantity = 0;
  Money _amount = Money.zero();

  String get amount => _amount.toString();

  int get quantity => _quantity;
  File? file;

  String get total => _amount.multiply(_quantity).toString();

  void setAmount(String amountString) {
    num amount = num.tryParse(amountString) ?? 0;
    _amount = Money(amount);
  }

  void setQuantity(String quantityString) {
    int quantity = int.tryParse(quantityString) ?? _quantity;
    _quantity = quantity;
  }
}
