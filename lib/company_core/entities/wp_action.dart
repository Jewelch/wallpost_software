const createExpenseActionString = "expense_request";
const createLeaveActionString = "leave_request";
const adjustPayrollActionString = "adjust_payroll";

enum WPAction {
  CreateExpenseRequest,
  CreateLeave,
  PayrollAdjustment,
}

WPAction? initializeWpActionFromString(String itemName) {
  if (itemName == createExpenseActionString) return WPAction.CreateExpenseRequest;
  if (itemName == createLeaveActionString) return WPAction.CreateLeave;
  if (itemName == adjustPayrollActionString) return WPAction.PayrollAdjustment;

  return null;
}
