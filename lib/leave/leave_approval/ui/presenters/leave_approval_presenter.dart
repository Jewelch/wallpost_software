import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '../../services/leave_approver.dart';
import '../../services/leave_rejector.dart';
import '../view_contracts/leave_approval_view.dart';

class LeaveApprovalPresenter {
  final LeaveApprovalView _view;
  final LeaveApprover _approver;
  final LeaveRejector _rejector;
  var _didPerformApprovalSuccessfully = false;
  var _didPerformRejectionSuccessfully = false;
  String? _reasonErrorMessage;

  LeaveApprovalPresenter.initWith(this._view, this._approver, this._rejector);

  LeaveApprovalPresenter(this._view)
      : _approver = LeaveApprover(),
        _rejector = LeaveRejector();

  Future<void> approve(String companyId, String leaveId) async {
    if (_didPerformApprovalSuccessfully) return;

    _view.showLoader();
    try {
      await _approver.approve(companyId, leaveId);
      _didPerformApprovalSuccessfully = true;
      _view.onDidPerformActionSuccessfully(leaveId);
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Approval Failed", e.userReadableMessage);
    }
  }

  Future<void> reject(String companyId, String leaveId, String rejectionReason) async {
    if (_didPerformRejectionSuccessfully) return;

    if (rejectionReason.isEmpty) {
      _reasonErrorMessage = "Please enter a valid reason";
      _view.notifyInvalidRejectionReason();
      return;
    }

    _reasonErrorMessage = null;
    _view.showLoader();
    try {
      await _rejector.reject(companyId, leaveId, rejectionReason: rejectionReason);
      _didPerformRejectionSuccessfully = true;
      _view.onDidPerformActionSuccessfully(leaveId);
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
