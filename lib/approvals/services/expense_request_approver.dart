import 'package:wallpost/approvals/entities/expense_request_approval.dart';

class ExpenseRequestApprover {
  Future<void> approve(ExpenseRequestApproval approval) {
    return Future.value(null);
  }

  Future<void> reject(ExpenseRequestApproval approval, String reason) {
    return Future.value(null);
  }
}
