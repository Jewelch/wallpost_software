import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/services/task_employees_list_provider.dart';
import 'package:wallpost/task/ui/views/task_employee_list/task_employee_list_tile.dart';

abstract class EmployeesListView {
  void reloadData();

  void onEmployeeAdded();

  void onEmployeeRemoved();
}

class EmployeesListPresenter {
  final EmployeesListView _view;
  final TaskEmployeesListProvider _provider;
  List<TaskEmployee> _employees = [];
  List<TaskEmployee> _selectedEmployees = [];
  String _errorMessage;
  String _searchText;

  EmployeesListPresenter(this._view) : _provider = TaskEmployeesListProvider();

  Future<void> loadNextListOfEmployees(String searchText) async {
    if (_provider.isLoading || _provider.didReachListEnd) return null;

    _searchText = searchText;
    _resetErrors();

    try {
      var employeesList = await _provider.getNext(searchText: _searchText);
      _employees.addAll(employeesList);
      _view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  //MARK: Functions to get employees list count and views

  int getNumberOfEmployees() {
    if (_hasErrors()) return _employees.length + 1;

    if (_employees.isEmpty) return 1;

    if (_provider.didReachListEnd) {
      return _employees.length;
    } else {
      return _employees.length + 1;
    }
  }

  Widget getEmployeeViewForIndex(int index) {
    if (_shouldShowErrorAtIndex(index)) return _buildErrorView(_errorMessage);

    if (_employees.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < _employees.length) {
      return _buildEmployeeViewForIndex(index);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == _employees.length;
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        loadNextListOfEmployees(_searchText);
        _view.reloadData();
      },
    );
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (_provider.didReachListEnd) {
      return ErrorListTile(
        'There are no employees to show. Tap here to reload.',
        onTap: () {
          _provider.reset();
          loadNextListOfEmployees(_searchText);
          _view.reloadData();
        },
      );
    } else {
      return LoaderListTile();
    }
  }

  Widget _buildEmployeeViewForIndex(int index) {
    return EmployeeListTile(
      isEmployeeSelected(_employees[index]),
      _employees[index],
      onEmployeeListTileTap: () {
        if (isEmployeeSelected(_employees[index])) {
          _selectedEmployees.removeWhere((selectedEmployee) =>
              selectedEmployee.fullName == _employees[index].fullName);
          _view.onEmployeeRemoved();
        } else {
          _selectedEmployees.add(_employees[index]);
          _view.onEmployeeAdded();
        }
      },
    );
  }

  //MARK: Functions to get selected employee count and views

  List<TaskEmployee> getSelectedEmployeesList() {
    return _selectedEmployees;
  }

  int getNumberOfSelectedEmployees() {
    return _selectedEmployees.length;
  }

  Widget getSelectedEmployeeViewForIndex(int index) {
    return RaisedButton(
      textColor: AppColors.filtersTextGreyColor,
      color: AppColors.filtersBackgroundGreyColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side:
            BorderSide(color: AppColors.filtersBackgroundGreyColor, width: .5),
      ),
      child: Row(
        children: [
          Text(
            _selectedEmployees[index].fullName,
            style: TextStyle(color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SvgPicture.asset('assets/icons/delete_icon.svg',
                width: 15, height: 15),
          ),
        ],
      ),
      onPressed: () {
        _selectedEmployees.removeAt(index);
        _view.onEmployeeRemoved();
      },
    );
  }

  //MARK: Util functions

  void reset() {
    _employees.clear();
    _provider.reset();
    _resetErrors();
    _view.reloadData();
  }

  void resetFilter() {
    _selectedEmployees.clear();
    _view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }

  bool isEmployeeSelected(TaskEmployee employee) {
    for (TaskEmployee selectedEmployee in _selectedEmployees) {
      if (selectedEmployee.fullName == employee.fullName) return true;
    }

    return false;
  }
}
