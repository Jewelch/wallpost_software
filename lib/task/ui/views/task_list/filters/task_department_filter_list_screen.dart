import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_department.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/services/task_department_list_provider.dart';

class TaskDepartmentFilterListScreen extends StatefulWidget {
  final TaskListFilters _filters;

  TaskDepartmentFilterListScreen(this._filters);

  @override
  _TaskDepartmentFilterListScreenState createState() => _TaskDepartmentFilterListScreenState();
}

class _TaskDepartmentFilterListScreenState extends State<TaskDepartmentFilterListScreen> {
  final List<TaskDepartment> _departments = [];
  final TaskDepartmentListProvider _provider = TaskDepartmentListProvider();
  final _filterListController = MultiSelectFilterListController();

  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Select Department',
      items: [],
      selectedItems: widget._filters.departments.map((e) => e.name).toList(),
      searchBarHint: 'Search by department name',
      noItemsMessage: 'There are no departments to show.',
      controller: _filterListController,
      onRefresh: () {
        _provider.reset();
        _departments.clear();
        getDepartments();
      },
      onRetry: () {
        getDepartments();
      },
      didReachEndOfList: () {
        getDepartments();
      },
      onSearchTextChanged: (_) {
        _provider.reset();
        _departments.clear();
        getDepartments();
      },
      onFiltersSelectionComplete: () {
        var selectedIndices = _filterListController.getSelectedIndices();
        List<TaskDepartment> selectedDepartments = [];
        for (int index in selectedIndices) {
          selectedDepartments.add(_departments[index]);
        }
        Navigator.pop(context, selectedDepartments);
      },
    );
  }

  void getDepartments() async {
    if (_provider.isLoading) return;

    try {
      var departmentList = await _provider.getNext(searchText: _filterListController.getSearchText());
      _departments.addAll(departmentList);
      _filterListController.addItems(departmentList.map((e) => e.name).toList());
    } on WPException catch (e) {
      _filterListController.showError(e.userReadableMessage);
    }
  }
}
