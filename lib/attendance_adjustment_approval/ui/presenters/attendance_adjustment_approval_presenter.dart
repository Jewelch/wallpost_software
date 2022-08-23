import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_approver.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_rejector.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/view_contracts/attendance_adjustment_approval_view.dart';

class AttendanceAdjustmentApprovalPresenter {
  final AttendanceAdjustmentApprovalView _view;
  final AttendanceAdjustmentApprover _approver;
  final AttendanceAdjustmentRejector _rejector;

  AttendanceAdjustmentApprovalPresenter.initWith(this._view, this._approver, this._rejector);

  AttendanceAdjustmentApprovalPresenter(this._view)
      : _approver = AttendanceAdjustmentApprover(),
        _rejector = AttendanceAdjustmentRejector();

  Future<void> approve(AttendanceAdjustmentApproval approval) async {
    try {
      await _approver.approve(approval);
      _view.onDidApproveOrRejectSuccessfully(approval);
    } on WPException catch (e) {
      _view.onDidFailToApproveOrReject("Approval Failed", e.userReadableMessage);
    }
  }

  Future<bool> reject(AttendanceAdjustmentApproval approval, String rejectionReason) async {
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
