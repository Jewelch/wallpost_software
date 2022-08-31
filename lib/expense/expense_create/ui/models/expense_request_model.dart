import 'dart:io';

import 'package:wallpost/_shared/money/money.dart';

import '../../entities/expense_category.dart';

class ExpenseRequestModel {
  DateTime date = DateTime.now();
  ExpenseCategory? mainCategory;
  ExpenseCategory? subCategory;
  ExpenseCategory? project;
  Money? rate;
  int? quantity;
  String? description;
  File? file;

  String? loadCategoriesError;
  String? rateError;
  String? quantityError;
}
