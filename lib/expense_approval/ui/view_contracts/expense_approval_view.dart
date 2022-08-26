import 'package:wallpost/expense_approval/entities/expense_approval.dart';

abstract class ExpenseApprovalView {
  void onDidFailToApproveOrReject(String title, String message);

  void onDidApproveOrRejectSuccessfully(ExpenseApproval approval);
}
