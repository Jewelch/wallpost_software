abstract class NotificationRouter {
  void goToExpenseDetailScreen(String companyId, String expenseId);

  void goToExpenseDetailScreenForApproval(String companyId, String expenseId);

  void goToLeaveDetailScreen(String companyId, String leaveId);

  void goToLeaveDetailScreenForApproval(String companyId, String leaveId);

  void goToAttendanceAdjustmentDetailScreen(String companyId, String attendanceId);

  void goToAttendanceAdjustmentDetailScreenForApproval(String companyId, String attendanceId);
}
