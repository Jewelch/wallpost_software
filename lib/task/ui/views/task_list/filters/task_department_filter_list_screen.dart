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
  final TaskDepartmentListProvider _provider = TaskDepartmentListProvider();
  final List<TaskDepartment> _departments = [];
  final List<TaskDepartment> _selectedDepartments = [];
  var _searchText = '';
  bool _showMessage = false;
  String _message;

  @override
  void initState() {
    _selectedDepartments.addAll(widget._filters.departments);
    _getDepartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MultiSelectFilterList(
            screenTitle: 'Select Departments',
            items: _departments.map((e) => e.name).toList(),
            selectedItems: _selectedDepartments.map((e) => e.name).toList(),
            searchBarHint: 'Search by department name',
            showMessage: _showMessage,
            message: _message,
            showLoaderAtEnd: _provider.didReachListEnd ? false : true,
            onSearchTextChanged: (searchText) {
              _provider.reset();
              _departments.clear();
              _searchText = searchText;
              _getDepartments();
            },
            onRefresh: () {
              setState(() => _departments.clear());
              _provider.reset();
              _getDepartments();
            },
            onRetry: () {
              setState(() => _getDepartments());
            },
            didReachEndOfList: () {
              _getDepartments();
            },
            onFilterSelected: (title) {
              setState(() {
                _selectedDepartments.add(_departments.firstWhere((e) => e.name == title));
              });
            },
            onFilterDeselected: (title) {
              setState(() {
                _selectedDepartments.removeWhere((e) => e.name == title);
              });
            },
            onFilterSelectionComplete: () {
              widget._filters.departments.clear();
              widget._filters.departments.addAll(_selectedDepartments);
              Navigator.pop(context, true);
            },
          ),
        ),
      ],
    );
  }

  void _getDepartments() async {
    if (_provider.isLoading) return;

    setState(() => _showMessage = false);
    try {
      var departmentList = await _provider.getNext(searchText: _searchText);
      setState(() {
        _departments.addAll(departmentList);
        if (_departments.length == 0) {
          _showMessage = true;
          _message = 'There are no departments to show.';
        }
      });
    } on WPException catch (error) {
      setState(() {
        _showMessage = true;
        _message = error.userReadableMessage;
      });
    }
  }
}
