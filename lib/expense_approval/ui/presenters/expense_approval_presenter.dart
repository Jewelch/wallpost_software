import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '../../entities/expense_approval.dart';
import '../../services/expense_approver.dart';
import '../../services/expense_rejector.dart';
import '../view_contracts/expense_approval_view.dart';

class ExpenseApprovalPresenter {
  final ExpenseApprovalView _view;
  final ExpenseApprover _approver;
  final ExpenseRejector _rejector;

  ExpenseApprovalPresenter.initWith(this._view, this._approver, this._rejector);

  ExpenseApprovalPresenter(this._view)
      : _approver = ExpenseApprover(),
        _rejector = ExpenseRejector();

  Future<void> approve(ExpenseApproval approval) async {
    try {
      await _approver.approve(approval);
      _view.onDidApproveOrRejectSuccessfully(approval);
    } on WPException catch (e) {
      _view.onDidFailToApproveOrReject("Approval Failed", e.userReadableMessage);
    }
  }

  Future<bool> reject(ExpenseApproval approval, String rejectionReason) async {
    try {
      await _rejector.reject(approval, rejectionReason: rejectionReason);
      _view.onDidApproveOrRejectSuccessfully(approval);
      return true;
    } on WPException catch (e) {
      _view.onDidFailToApproveOrReject("Rejection Failed", e.userReadableMessage);
      return false;
    }
  }
}
