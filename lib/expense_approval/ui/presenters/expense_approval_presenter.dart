import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '../../services/expense_approver.dart';
import '../../services/expense_rejector.dart';
import '../view_contracts/expense_approval_view.dart';

class ExpenseApprovalPresenter {
  final ExpenseApprovalView _view;
  final ExpenseApprover _approver;
  final ExpenseRejector _rejector;
  var _didPerformAction = false;

  ExpenseApprovalPresenter.initWith(this._view, this._approver, this._rejector);

  ExpenseApprovalPresenter(this._view)
      : _approver = ExpenseApprover(),
        _rejector = ExpenseRejector();

  Future<void> approve(String companyId, String expenseId) async {
    _didPerformAction = true;
    try {
      await _approver.approve(companyId, expenseId);
      _view.onDidApproveOrRejectSuccessfully(expenseId);
    } on WPException catch (e) {
      _view.onDidFailToApproveOrReject("Approval Failed", e.userReadableMessage);
    }
  }

  Future<bool> reject(String companyId, String expenseId, String rejectionReason) async {
    _didPerformAction = true;
    try {
      await _rejector.reject(companyId, expenseId, rejectionReason: rejectionReason);
      _view.onDidApproveOrRejectSuccessfully(expenseId);
      return true;
    } on WPException catch (e) {
      _view.onDidFailToApproveOrReject("Rejection Failed", e.userReadableMessage);
      return false;
    }
  }

  get didPerformAction => _didPerformAction;
}
