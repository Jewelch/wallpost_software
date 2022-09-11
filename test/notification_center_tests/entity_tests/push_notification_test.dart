import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';

void main() {
  test("expense approval required notification", () {
    var notification = Mocks.expenseApprovalRequiredNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), true);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("expense approved notification", () {
    var notification = Mocks.expenseApprovedNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), true);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("expense rejected notification", () {
    var notification = Mocks.expenseRejectedNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), true);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("leave approval required notification", () {
    var notification = Mocks.leaveApprovalRequiredNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), true);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("leave approved notification", () {
    var notification = Mocks.leaveApprovedNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), true);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("expense leave rejected notification", () {
    var notification = Mocks.leaveRejectedNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), true);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("attendance adjustment approval required notification", () {
    var notification = Mocks.attendanceAdjustmentApprovalRequiredNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), true);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("attendance adjustment approved notification", () {
    var notification = Mocks.attendanceAdjustmentApprovedNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), true);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), false);
  });

  test("attendance adjustment rejected notification", () {
    var notification = Mocks.attendanceAdjustmentRejectedNotification;

    expect(notification.isExpenseApprovalRequiredNotification(), false);
    expect(notification.isExpenseApprovedNotification(), false);
    expect(notification.isExpenseRejectedNotification(), false);
    expect(notification.isLeaveApprovalRequiredNotification(), false);
    expect(notification.isLeaveApprovedNotification(), false);
    expect(notification.isLeaveRejectedNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovalRequiredNotification(), false);
    expect(notification.isAttendanceAdjustmentApprovedNotification(), false);
    expect(notification.isAttendanceAdjustmentRejectedNotification(), true);
  });
}
