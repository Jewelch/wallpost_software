import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/views/attendance_adjustment_approval_list_screen.dart';
import 'package:wallpost/expense/expense_detail/ui/views/expense_detail_screen.dart';
import 'package:wallpost/leave/leave_detail/ui/views/leave_detail_screen.dart';
import 'package:wallpost/notification_center/notification_router.dart';

import '../main.dart';

class NotificationScreenRouter implements NotificationRouter {
  @override
  void goToExpenseDetailScreen(String companyId, String expenseId) {
    ScreenPresenter.present(
      ExpenseDetailScreen(companyId: companyId, expenseId: expenseId),
      navigatorKey.currentContext!,
    );
  }

  @override
  void goToExpenseDetailScreenForApproval(String companyId, String expenseId) {
    ScreenPresenter.present(
      ExpenseDetailScreen(
        companyId: companyId,
        expenseId: expenseId,
        isLaunchingDetailScreenForApproval: true,
      ),
      navigatorKey.currentContext!,
    );
  }

  @override
  void goToLeaveDetailScreen(String companyId, String leaveId) {
    ScreenPresenter.present(
      LeaveDetailScreen(companyId: companyId, leaveId: leaveId),
      navigatorKey.currentContext!,
    );
  }

  @override
  void goToLeaveDetailScreenForApproval(String companyId, String leaveId) {
    ScreenPresenter.present(
      LeaveDetailScreen(
        companyId: companyId,
        leaveId: leaveId,
        isLaunchingDetailScreenForApproval: true,
      ),
      navigatorKey.currentContext!,
    );
  }

  @override
  void goToAttendanceAdjustmentDetailScreen(String companyId, String attendanceId) {
    //do nothing as we do not have an attendance adjustment detail screen
  }

  @override
  void goToAttendanceAdjustmentDetailScreenForApproval(String companyId, String attendanceId) {
    ScreenPresenter.present(
      AttendanceAdjustmentApprovalListScreen(companyId: companyId),
      navigatorKey.currentContext!,
    );
  }
}
