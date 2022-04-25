import 'dart:io';

import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';

class ExpenseRequestModel {
  ExpenseCategory? selectedMainCategory;
  ExpenseCategory? selectedSubCategory;
  ExpenseCategory? selectedProject;
  DateTime date = DateTime.now();
  String description = "";
  int quantity = 0;
  Money _amount = Money.zero();

  String get amount => _amount.toString();
  File? file;

  String get rate => _amount.multiply(quantity).toString();

  String get total => "";

  void setAmount(num amount) {
    _amount = Money(amount);
  }
}
