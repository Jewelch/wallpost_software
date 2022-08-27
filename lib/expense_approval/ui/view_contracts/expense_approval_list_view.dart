import 'package:wallpost/expense_approval/entities/expense_approval.dart';

abstract class ExpenseApprovalListView {
  void showLoader();

  void showErrorMessage();

  void showNoItemsMessage();

  void updateList();

  void showExpenseDetail(ExpenseApproval approval);
}
