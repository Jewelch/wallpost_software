import 'package:wallpost/expense_requests/entities/expense_request_form.dart';

abstract class PerExpenseRequestView {
  void notifyMissingParentCategory(String message);

  void notifyMissingChildCategory(String message);

  void notifyMissingDate(String message);

  ExpenseRequestForm? getExpenseRequest();
}