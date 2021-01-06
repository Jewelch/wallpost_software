import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/services/task_employee_list_provider.dart';

class TaskAssigneeFilterListScreen extends StatefulWidget {
  final TaskListFilters _filters;

  TaskAssigneeFilterListScreen(this._filters);

  @override
  _TaskAssigneeFilterListScreenState createState() => _TaskAssigneeFilterListScreenState();
}

class _TaskAssigneeFilterListScreenState extends State<TaskAssigneeFilterListScreen> {
  final List<TaskEmployee> _employees = [];
  final TaskEmployeeListProvider _provider = TaskEmployeeListProvider();
  final _filterListController = MultiSelectFilterListController();

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Select Assignees',
      items: [],
      selectedItems: widget._filters.assignees.map((e) => e.fullName).toList(),
      searchBarHint: 'Search by assignee name',
      noItemsMessage: 'There are no employees to show.',
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
        List<TaskEmployee> selectedDepartments = [];
        for (int index in selectedIndices) {
          selectedDepartments.add(_employees[index]);
        }
        Navigator.pop(context, selectedDepartments);
      },
    );
  }

  void getEmployees() async {
    if (_provider.isLoading) return;

    try {
      var employeeList = await _provider.getNext(searchText: _filterListController.getSearchText());
      _employees.addAll(employeeList);
      _filterListController.addItems(employeeList.map((e) => e.fullName).toList());
    } on WPException catch (e) {
      _filterListController.showError(e.userReadableMessage);
    }
  }
}
