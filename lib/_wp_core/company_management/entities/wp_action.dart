const createExpenseActionString = "expense_request";
const createLeaveActionString = "leave_request";
const adjustPayrollActionString = "adjust_payroll";

enum WPAction {
  Expense,
  Leave,
  PayrollAdjustment;

  static WPAction? initFromString(String itemName) {
    if (itemName == createExpenseActionString) return WPAction.Expense;
    if (itemName == createLeaveActionString) return WPAction.Leave;
    if (itemName == adjustPayrollActionString) return WPAction.PayrollAdjustment;

    return null;
  }

  String toReadableString() {
    switch (this) {
      case WPAction.Expense:
        return "Expense";
      case WPAction.Leave:
        return "Leave";
      case WPAction.PayrollAdjustment:
        return "Payroll Adjustment";
    }
  }
}
