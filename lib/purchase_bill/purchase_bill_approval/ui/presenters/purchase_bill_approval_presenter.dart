import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/services/purchase_bill_approver.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/services/purchase_bill_rejector.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/view_contracts/purchase_bill_approval_view.dart';

import '../../../../notification_center/notification_center.dart';

class PurchaseBillApprovalPresenter {
  final PurchaseBillApprovalView _view;
  final PurchaseBillApproval _approver;
  final PurchaseBillRejector _rejector;
  final NotificationCenter _notificationCenter;
  var _didPerformApprovalSuccessfully = false;
  var _didPerformRejectionSuccessfully = false;
  String? _reasonErrorMessage;

  PurchaseBillApprovalPresenter.initWith(
    this._view,
    this._approver,
    this._rejector,
    this._notificationCenter,
  );

  PurchaseBillApprovalPresenter(this._view)
      : _approver = PurchaseBillApproval(),
        _rejector = PurchaseBillRejector(),
        _notificationCenter = NotificationCenter.getInstance();

  Future<void> approve(String companyId, String billId) async {
    if (_didPerformApprovalSuccessfully) return;
    _view.showLoader();
    try {
      await _approver.approve(companyId, billId);
      _notificationCenter.updateCount();
      _didPerformApprovalSuccessfully = true;
      _view.onDidPerformActionSuccessfully(billId);
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Approval Failed", e.userReadableMessage);
    }
  }

  Future<void> massApprove(String companyId, List<String> billIds) async {
    if (_didPerformApprovalSuccessfully) return;

    _view.showLoader();
    try {
       await _approver.massApprove(companyId, billIds);
      _notificationCenter.updateCount();
      _didPerformApprovalSuccessfully = true;
      _view.onDidPerformActionSuccessfully(billIds.join(','));
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Approval Failed", e.userReadableMessage);
    }
  }

  Future<void> reject(String companyId, String billId, String rejectionReason) async {
    if (_didPerformRejectionSuccessfully) return;

    if (rejectionReason.isEmpty) {
      _reasonErrorMessage = "Please enter a valid reason";
      _view.notifyInvalidRejectionReason("Please enter a valid reason");
      return;
    }

    _reasonErrorMessage = null;
    _view.showLoader();
    try {
      await _rejector.reject(companyId, billId, rejectionReason: rejectionReason);
      _notificationCenter.updateCount();
      _didPerformRejectionSuccessfully = true;
      _view.onDidPerformActionSuccessfully(billId);
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Rejection Failed", e.userReadableMessage);
    }
  }

  Future<void> massReject(String companyId, List<String> billIds, String rejectionReason) async {
    if (_didPerformRejectionSuccessfully) return;

    if (rejectionReason.isEmpty) {
      _reasonErrorMessage = "Please enter a valid reason";
      _view.notifyInvalidRejectionReason("Please enter a valid reason");
      return;
    }

    _reasonErrorMessage = null;
    _view.showLoader();
    try {
      await _rejector.massReject(companyId, billIds, rejectionReason: rejectionReason);
      _notificationCenter.updateCount();
      _didPerformRejectionSuccessfully = true;
      _view.onDidPerformActionSuccessfully(billIds.join(','));
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
