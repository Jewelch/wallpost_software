import 'package:wallpost/_wp_core/company_management/entities/company.dart';
import 'package:wallpost/_wp_core/company_management/entities/employee.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';

class Permissions {
  final Company _company;
  final Employee _employee;

  Permissions.initWith(this._company, this._employee);

  // Permissions.forSelectedCompany()
  Permissions()
      : this._company = SelectedCompanyProvider().getSelectedCompanyForCurrentUser(),
        this._employee = SelectedEmployeeProvider().getSelectedEmployeeForCurrentUser();

  //?
  bool shouldShowFinancialWidgets() => false;

  // company has task module and user role doesn't matter
  bool canCreateTask() => false;

  //?
  bool canRequestLeave() => false;

  //?
  bool canCreateHandover() => false;

// bool canApproveEmployeeHandover(handover)=> false;
// bool canApproveExpense(expense)=> false;
// bool canApproveTask(task)=> false;
// bool canApproveLeave(leave)=> false;
// bool canApproveAttendanceAdjustment(attendanceAdjustmentRequest)=> false;
}
