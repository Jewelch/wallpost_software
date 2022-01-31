import 'package:wallpost/company_list/entities/company.dart';
import 'package:wallpost/company_list/entities/employee.dart';
import 'package:wallpost/company_list/services/selected_company_provider.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';
import 'package:wallpost/permission/entities/request_item.dart';

class Permissions {
  final Company _company;
  final Employee _employee;
  final List<RequestItem> _requestItems;

  Permissions.initWith(this._company, this._employee, this._requestItems);

  Permissions()
      : this._company =
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser(),
        this._employee =
            SelectedEmployeeProvider().getSelectedEmployeeForCurrentUser(),
        this._requestItems = [];

  bool canCreateTask() => _requestItems.contains(RequestItem.Task);

  bool canCreateExpenseRequest() =>
      _requestItems.contains(RequestItem.ExpenseRequest);

// bool canRequestLeave() => _requestItems.contains(RequestItem.LeaveRequest);
// bool canCreateHandover() => false;

// bool canApproveEmployeeHandover(handover)=> false;
// bool canApproveTask(task)=> false;
// bool canApproveLeave(leave)=> false;
// bool canApproveAttendanceAdjustment(attendanceAdjustmentRequest)=> false;
}
