import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '../../../../notification_center/notification_center.dart';
import '../../services/expense_approver.dart';
import '../../services/expense_rejector.dart';
import '../view_contracts/expense_approval_view.dart';

class ExpenseApprovalPresenter {
  final ExpenseApprovalView _view;
  final ExpenseApprover _approver;
  final ExpenseRejector _rejector;
  final NotificationCenter _notificationCenter;
  var _didPerformApprovalSuccessfully = false;
  var _didPerformRejectionSuccessfully = false;
  String? _reasonErrorMessage;

  ExpenseApprovalPresenter.initWith(
    this._view,
    this._approver,
    this._rejector,
    this._notificationCenter,
  );

  ExpenseApprovalPresenter(this._view)
      : _approver = ExpenseApprover(),
        _rejector = ExpenseRejector(),
        _notificationCenter = NotificationCenter.getInstance();

  Future<void> approve(String companyId, String expenseId) async {
    if (_didPerformApprovalSuccessfully) return;

    _view.showLoader();
    try {
      await _approver.approve(companyId, expenseId);
      _notificationCenter.updateCount();
      _didPerformApprovalSuccessfully = true;
      _view.onDidPerformActionSuccessfully(expenseId);
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Approval Failed", e.userReadableMessage);
    }
  }

  Future<void> reject(String companyId, String expenseId, String rejectionReason) async {
    if (_didPerformRejectionSuccessfully) return;

    if (rejectionReason.isEmpty) {
      _reasonErrorMessage = "Please enter a valid reason";
      _view.notifyInvalidRejectionReason();
      return;
    }

    _reasonErrorMessage = null;
    _view.showLoader();
    try {
      await _rejector.reject(companyId, expenseId, rejectionReason: rejectionReason);
      _notificationCenter.updateCount();
      _didPerformRejectionSuccessfully = true;
      _view.onDidPerformActionSuccessfully(expenseId);
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Rejection Failed", e.userReadableMessage);
    }
  }

  bool isApprovalInProgress() {
    return _approver.isLoading;
  }

  bool isRejectionInProgress() {
    return _rejector.isLoading;
  }

  String getApproveButtonTitle() {
    return _didPerformApprovalSuccessfully ? "Approved!" : "Submit";
  }

  String getRejectButtonTitle() {
    return _didPerformRejectionSuccessfully ? "Rejected!" : "Submit";
  }

  String? getRejectionReasonError() {
    return _reasonErrorMessage;
  }
}
