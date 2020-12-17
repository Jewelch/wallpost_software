import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';
import 'package:wallpost/leave/entities/leave_type.dart';
import 'package:wallpost/leave/services/leave_employees_list_provider.dart';
import 'package:wallpost/leave/services/leave_types_provider.dart';

abstract class LeaveListView {
  void reloadData();
}

class LeaveListFilterPresenter {
  final LeaveListView view;
  final LeaveTypesProvider leaveTypesProvider;
  final LeaveEmployeesListProvider employeesListProvider;

  List<LeaveType> leaveTypes = [];
  List<LeaveEmployee> employees = [];

  LeaveListFilterPresenter(this.view)
      : leaveTypesProvider = LeaveTypesProvider(),
        employeesListProvider =
            LeaveEmployeesListProvider.subordinatesProvider();

  Future<void> loadLeaveType() async {
    if (leaveTypesProvider.isLoading) return null;

    try {
      var leaveTypesList = await leaveTypesProvider.getLeaveTypes();
      leaveTypes.addAll(leaveTypesList);
      view.reloadData();
    } on WPException catch (_) {
      //fail silently as this is not a critical error
      view.reloadData();
    }
  }

  Future<void> loadEmployees() async {
    if (employeesListProvider.isLoading ||
        employeesListProvider.didReachListEnd) return null;

    try {
      var employeesList = await employeesListProvider.getNext();
      employees.addAll(employeesList);
      view.reloadData();
    } on WPException catch (_) {
      //fail silently as this is not a critical error
      view.reloadData();
    }
  }

  void loadFilteredEmployees(List<LeaveEmployee> employeesList) {
    employees.clear();
    employees.addAll(employeesList);
    view.reloadData();
  }

  //MARK: Util functions

  bool isLoadingLeaveTypes() {
    return leaveTypesProvider.isLoading;
  }

  bool isLoadingEmployees() {
    return employeesListProvider.isLoading;
  }
}
