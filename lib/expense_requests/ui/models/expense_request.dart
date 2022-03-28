import 'dart:io';

import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';

class ExpenseRequest {
  ExpenseCategory? selectedMainCategory;
  ExpenseCategory? selectedSubCategory;
  ExpenseCategory? selectedProject;
  DateTime date = DateTime.now();
  String description = "";
  int quantity = 0;
  Money rate = Money.zero();
  File? file;

  // TODO : ask Obaid about how to calculate
  String get amount => "";

  String get total => "";
}

