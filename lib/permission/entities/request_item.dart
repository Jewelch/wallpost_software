RequestItem? initializeRequestFromString(String itemName) {
  if (itemName == 'myportal_create_task') return RequestItem.Task;
  if (itemName == 'leave_request') return RequestItem.LeaveRequest;
  if (itemName == 'expense_request') return RequestItem.ExpenseRequest;
  if (itemName == 'overtime_request') return RequestItem.OvertimeRequest;
}

enum RequestItem { Task, ExpenseRequest, LeaveRequest, OvertimeRequest }
