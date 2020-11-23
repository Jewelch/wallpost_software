import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/services/task_employees_list_provider.dart';
import 'package:wallpost/task/ui/views/task_employee_list/task_employee_list_tile.dart';

abstract class EmployeeListView {
  void reloadData();
}

class EmployeeListPresenter {
  final EmployeeListView view;
  final TaskEmployeesListProvider provider;
  List<TaskEmployee> employee = [];
  String _errorMessage;

  EmployeeListPresenter(this.view) : provider = TaskEmployeesListProvider();

  EmployeeListPresenter.initWith(this.view, this.provider);

  Future<void> loadNextListOfEmployee() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var employeeList = await provider.getNext();
      employee.addAll(employeeList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  Future<List<Department>> getListOfDepartments() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var employeeList = await provider.getNext();
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return employee.length + 1;

    if (employee.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return employee.length;
    } else {
      return employee.length + 1;
    }
  }

  Widget getViewAtIndex(int index) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (employee.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < employee.length) {
      return EmployeeListTile(employee[index]);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == employee.length;
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (provider.didReachListEnd) {
      return ErrorListTile(
          'There are no employee to show. Tap here to reload.');
    } else {
      return LoaderListTile();
    }
  }

  //MARK: Util functions

  void reset() {
    provider.reset();
    _resetErrors();
    employee.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
