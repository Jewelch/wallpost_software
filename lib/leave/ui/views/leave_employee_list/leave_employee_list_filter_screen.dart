import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/services/leave_employees_list_provider.dart';

class LeaveEmployeeListFilterScreen extends StatefulWidget {
  final LeaveListFilters _filters;

  const LeaveEmployeeListFilterScreen(this._filters);
  @override
  _LeaveEmployeeListFilterScreenState createState() =>
      _LeaveEmployeeListFilterScreenState();
}

class _LeaveEmployeeListFilterScreenState
    extends State<LeaveEmployeeListFilterScreen> {
  final List<LeaveEmployee> _employees = [];
  final LeaveEmployeesListProvider _provider =
      LeaveEmployeesListProvider.allEmployeesProvider();
  final _filterListController = MultiSelectFilterListController();

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Select Applicant',
      items: [],
      selectedItems: widget._filters.applicants.map((e) => e.fullName).toList(),
      searchBarHint: 'Search by applicant name',
      noItemsMessage: 'There are no applicant to show.',
      controller: _filterListController,
      onRefresh: () {
        _provider.reset();
        _employees.clear();
        getEmployees();
      },
      onRetry: () {
        getEmployees();
      },
      didReachEndOfList: () {
        getEmployees();
      },
      onSearchTextChanged: (_) {
        _provider.reset();
        _employees.clear();
        getEmployees();
      },
      onFiltersSelectionComplete: () {
        var selectedIndices = _filterListController.getSelectedIndices();
        List<LeaveEmployee> selectedEmployee = [];
        for (int index in selectedIndices) {
          selectedEmployee.add(_employees[index]);
        }
        Navigator.pop(context, selectedEmployee);
      },
    );
  }

  void getEmployees() async {
    if (_provider.isLoading) return;

    try {
      var employeeList = await _provider.getNext(
          searchText: _filterListController.getSearchText());
      _employees.addAll(employeeList);
      _filterListController
          .addItems(employeeList.map((e) => e.fullName).toList());
      if (_provider.didReachListEnd) _filterListController.reachedListEnd();
    } on WPException catch (e) {
      _filterListController.showError(e.userReadableMessage);
    }
  }
}
