import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '../../../../notification_center/notification_center.dart';
import '../../../attendance_adjustment_approval_list/ui/view_contracts/attendance_adjustment_approval_view.dart';
import '../../services/attendance_adjustment_approver.dart';
import '../../services/attendance_adjustment_rejector.dart';

class AttendanceAdjustmentApprovalPresenter {
  final AttendanceAdjustmentApprovalView _view;
  final AttendanceAdjustmentApprover _approver;
  final AttendanceAdjustmentRejector _rejector;
  final NotificationCenter _notificationCenter;
  var _didPerformApprovalSuccessfully = false;
  var _didPerformRejectionSuccessfully = false;
  String? _reasonErrorMessage;

  AttendanceAdjustmentApprovalPresenter.initWith(
    this._view,
    this._approver,
    this._rejector,
    this._notificationCenter,
  );

  AttendanceAdjustmentApprovalPresenter(this._view)
      : _approver = AttendanceAdjustmentApprover(),
        _rejector = AttendanceAdjustmentRejector(),
        _notificationCenter = NotificationCenter.getInstance();

  Future<void> approve(String companyId, String attendanceAdjustmentId) async {
    if (_didPerformApprovalSuccessfully) return;

    _view.showLoader();
    try {
      await _approver.approve(companyId, attendanceAdjustmentId);
      _notificationCenter.updateCount();
      _didPerformApprovalSuccessfully = true;
      _view.onDidPerformActionSuccessfully(attendanceAdjustmentId);
    } on WPException catch (e) {
      _view.onDidFailToPerformAction("Approval Failed", e.userReadableMessage);
    }
  }

  Future<void> reject(String companyId, String attendanceAdjustmentId, String rejectionReason) async {
    if (_didPerformRejectionSuccessfully) return;

    if (rejectionReason.isEmpty) {
      _reasonErrorMessage = "Please enter a valid reason";
      _view.notifyInvalidRejectionReason();
      return;
    }

    _reasonErrorMessage = null;
    _view.showLoader();
    try {
      await _rejector.reject(companyId, attendanceAdjustmentId, rejectionReason: rejectionReason);
      _notificationCenter.updateCount();
      _didPerformRejectionSuccessfully = true;
      _view.onDidPerformActionSuccessfully(attendanceAdjustmentId);
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
