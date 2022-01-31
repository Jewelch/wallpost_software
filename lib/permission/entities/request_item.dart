const taskString = "myportal_create_task";
const leaveString = "leave_request";
const expenseString = "expense_request";
const overTimeString = "overtime_request";

RequestItem? initializeRequestFromString(String itemName) {
  if (itemName == taskString) return RequestItem.Task;
  if (itemName == leaveString) return RequestItem.LeaveRequest;
  if (itemName == expenseString) return RequestItem.ExpenseRequest;
  if (itemName == overTimeString) return RequestItem.OvertimeRequest;
}

enum RequestItem { Task, ExpenseRequest, LeaveRequest, OvertimeRequest }

extension RequestItemExtension on RequestItem {
  String toReadableString() {
    switch (this) {
      case RequestItem.Task:
        return taskString;
      case RequestItem.ExpenseRequest:
        return expenseString;
      case RequestItem.LeaveRequest:
        return leaveString;
      case RequestItem.OvertimeRequest:
        return overTimeString;
    }
  }
}
