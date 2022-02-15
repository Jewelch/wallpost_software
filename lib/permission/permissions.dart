import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/entities/wp_action.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/company_core/services/selected_employee_actions_provider.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class Permissions {
  final Company _company;
  final Employee _employee;
  final List<WPAction> _allowedActions;

  Permissions.initWith(this._company, this._employee, this._allowedActions);

  Permissions()
      : this._company = SelectedCompanyProvider().getSelectedCompanyForCurrentUser(),
        this._employee = SelectedEmployeeProvider().getSelectedEmployeeForCurrentUser(),
        this._allowedActions = SelectedEmployeeActionsProvider().getAllowedActionsForSelectedEmployee();

  bool canCreateTask() => _allowedActions.contains(WPAction.Task);

  bool canCreateExpenseRequest() => _allowedActions.contains(WPAction.ExpenseRequest);

// bool canRequestLeave() => _requestItems.contains(RequestItem.LeaveRequest);
// bool canCreateHandover() => false;
// bool canApproveEmployeeHandover(handover)=> false;
// bool canApproveTask(task)=> false;
// bool canApproveLeave(leave)=> false;
// bool canApproveAttendanceAdjustment(attendanceAdjustmentRequest)=> false;
}
