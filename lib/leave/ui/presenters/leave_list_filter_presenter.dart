import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/entities/leave_type.dart';
import 'package:wallpost/leave/services/leave_employees_list_provider.dart';
import 'package:wallpost/leave/services/leave_types_provider.dart';

abstract class LeaveListFiltersView {
  void reloadData();
  void resetAndReloadData();
}

class LeaveListFilterPresenter {
  final LeaveListFiltersView view;
  LeaveListFilters _filters;
  final LeaveTypesProvider leaveTypesProvider;
  final LeaveEmployeesListProvider employeesListProvider;
  List<LeaveType> _leaveTypes = [];
  List<LeaveEmployee> _applicants = [];

  LeaveListFilterPresenter(this.view, this._filters)
      : leaveTypesProvider = LeaveTypesProvider(),
        employeesListProvider =
            LeaveEmployeesListProvider.subordinatesProvider();

  void loadLeaveType() async {
    if (_filters.leaveType.isNotEmpty) {
      _leaveTypes.clear();
      _leaveTypes.addAll(_filters.leaveType);
      view.reloadData();
    } else {
      if (_leaveTypes.isNotEmpty) {
        view.reloadData();
        return;
      }
      if (leaveTypesProvider.isLoading) return;

      try {
        var leaveTypesList = await leaveTypesProvider.getLeaveTypes();
        _leaveTypes.addAll(leaveTypesList);
        view.reloadData();
      } on WPException catch (_) {
        view.reloadData();
      }
    }
  }

  void loadEmployees() async {
    if (_filters.applicants.isNotEmpty) {
      _applicants.clear();
      _applicants.addAll(_filters.applicants);
      view.reloadData();
    } else {
      if (_applicants.isNotEmpty) {
        view.reloadData();
        return;
      }
      if (employeesListProvider.isLoading) return;

      try {
        var employeeList = await employeesListProvider.getNext();
        _applicants.addAll(employeeList);
        view.reloadData();
      } on WPException catch (_) {
        //fail silently as this is not a critical error
        view.reloadData();
      }
    }
  }

  //MARK: Functions to get, select, and deselect leavetype

  List<LeaveType> getLeaveType() {
    return _leaveTypes;
  }

  List<int> getSelectedLeaveTypeIndices() {
    List<int> indices = [];
    for (LeaveType e in _filters.leaveType) {
      indices.add(_leaveTypes.indexOf(e));
    }
    return indices;
  }

  void selectLeaveTypeAtIndex(int index) {
    _filters.leaveType.add(_leaveTypes[index]);
    view.reloadData();
  }

  void deselectLeaveTypeAtIndex(int index) {
    _filters.leaveType.remove(_leaveTypes[index]);
    view.reloadData();
  }

  //MARK: Functions to get, select, and deselect applicant

  List<LeaveEmployee> getApplicant() {
    return _applicants;
  }

  List<int> getSelectedApplicantIndices() {
    List<int> indices = [];
    for (LeaveEmployee e in _filters.applicants) {
      indices.add(_applicants.indexOf(e));
    }
    return indices;
  }

  void selectApplicantAtIndex(int index) {
    _filters.applicants.add(_applicants[index]);
    view.reloadData();
  }

  void deselectApplicantAtIndex(int index) {
    _filters.applicants.remove(_applicants[index]);
    view.reloadData();
  }

  //MARK: Util functions

  void resetFilters() {
    _filters.resetSelectedLeaveType();
    _filters.resetSelectedApplicant();
    employeesListProvider.reset();
    leaveTypesProvider.reset();
    _applicants.clear();
    _leaveTypes.clear();
    view.resetAndReloadData();
  }

  bool isLoadingLeaveTypes() {
    return leaveTypesProvider.isLoading;
  }

  bool isLoadingEmployees() {
    return employeesListProvider.isLoading;
  }
}
