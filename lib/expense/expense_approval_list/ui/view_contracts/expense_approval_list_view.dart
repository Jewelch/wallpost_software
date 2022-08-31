import '../../entities/expense_approval_list_item.dart';

abstract class ExpenseApprovalListView {
  void showLoader();

  void showErrorMessage();

  void showNoItemsMessage();

  void updateList();

  void showExpenseDetail(ExpenseApprovalListItem approval);
}
