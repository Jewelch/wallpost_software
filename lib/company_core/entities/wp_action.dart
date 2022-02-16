const taskString = "myportal_create_task";
const leaveString = "leave_request";
const expenseString = "expense_request";
const overTimeString = "overtime_request";
const timesheetAdjustmentString = "timesheet_adjustment";

enum WPAction {
  Task,
  ExpenseRequest,
  LeaveRequest,
  OvertimeRequest,
  TimesheetAdjustment,
}

WPAction? initializeWpActionFromString(String itemName) {
  if (itemName == taskString) return WPAction.Task;
  if (itemName == leaveString) return WPAction.LeaveRequest;
  if (itemName == expenseString) return WPAction.ExpenseRequest;
  if (itemName == overTimeString) return WPAction.OvertimeRequest;
  if (itemName == timesheetAdjustmentString) return WPAction.TimesheetAdjustment;
  return null;
}

extension WPActionExtension on WPAction {
  String toReadableString() {
    switch (this) {
      case WPAction.Task:
        return taskString;
      case WPAction.ExpenseRequest:
        return expenseString;
      case WPAction.LeaveRequest:
        return leaveString;
      case WPAction.OvertimeRequest:
        return overTimeString;
      case WPAction.TimesheetAdjustment:
        return timesheetAdjustmentString;
    }
  }
}
