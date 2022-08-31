import 'package:wallpost/expense/expense__core/entities/expense_request.dart';

abstract class ExpenseListView {
  void showLoader();

  void showErrorMessage();

  void showNoItemsMessage();

  void updateList();

  void showExpenseDetail(ExpenseRequest expenseRequest);
}
