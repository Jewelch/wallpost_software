import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_file_uploader.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';

import 'expense_categories_mock.dart';

class MockFileUploader extends Mock implements WPFileUploader {}

class MockFile extends Mock implements File {}

var mockFile = MockFile();

var successFullUploadingFileResponse = {
  "any": "file1",
};

ExpenseRequestForm getExpenseRequestForm() {
  return ExpenseRequestForm(
      parentCategory: "parentCategory",
      category: "category",
      date: "date",
      description: "description",
      quantity: "1",
      amount: "2",
      file: mockFile,
      total: "1");
}

ExpenseRequestModel getValidExpenseRequestModel() {
  var expenseRequest = ExpenseRequestModel();
  var category = ExpenseCategory.fromJson(expenseCategoriesListResponse[2]);
  expenseRequest.selectedProject = category;
  expenseRequest.selectedSubCategory = category;
  expenseRequest.selectedMainCategory = category;
  expenseRequest.file = File("path");
  expenseRequest.setAmount("1");
  expenseRequest.setQuantity("1");
  return expenseRequest;
}

var successFullAddingExpenseRequestResponse = {
  "status": "success",
  "data": {"id": "24", "status": "success", "message": "Approval Sent."}
};

class MockExpenseCategory extends Mock implements ExpenseCategory {}
