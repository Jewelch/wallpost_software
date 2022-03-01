import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/per_expense_request_view.dart';

class MockFile extends Mock implements File {}

var mockFile = MockFile();

ExpenseRequestForm getExpenseRequest() {
  return ExpenseRequestForm(
      parentCategory: "parentCategory",
      category: "category",
      date: "date",
      description: "description",
      quantity: "1",
      rate: "2",
      amount: "2",
      files: [mockFile],
      total: "1");
}

class MockPerExpenseRequestView extends Mock implements PerExpenseRequestView {}

class MockExpenseCategory extends Mock implements ExpenseCategory {}

class MockExpenseRequest extends Mock implements ExpenseRequestForm {}
