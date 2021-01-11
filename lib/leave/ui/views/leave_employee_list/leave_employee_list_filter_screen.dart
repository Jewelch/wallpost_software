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
  _LeaveEmployeeListFilterScreenState createState() => _LeaveEmployeeListFilterScreenState();
}

class _LeaveEmployeeListFilterScreenState extends State<LeaveEmployeeListFilterScreen> {
  final LeaveEmployeesListProvider _provider = LeaveEmployeesListProvider.allEmployeesProvider();
  final List<LeaveEmployee> _applicants = [];
  final List<LeaveEmployee> _selectedApplicants = [];
  bool _showMessage;
  String _message;
  String _searchText;

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Select Applicants',
      items: _applicants.map((e) => e.fullName).toList(),
      selectedItems: widget._filters.applicants.map((e) => e.fullName).toList(),
      searchBarHint: 'Search by applicant name',
      showMessage: _showMessage,
      message: _message,
      showLoaderAtEnd: _provider.didReachListEnd ? false : true,
      onSearchTextChanged: (searchText) {
        _provider.reset();
        _applicants.clear();
        _searchText = searchText;
        getEmployees();
      },
      onRefresh: () {
        setState(() => _applicants.clear());
        _provider.reset();
        getEmployees();
      },
      onRetry: () {
        setState(() => getEmployees());
      },
      didReachEndOfList: () {
        getEmployees();
      },
      onFilterSelected: (title) {
        setState(() {
          _selectedApplicants.add(_applicants.firstWhere((e) => e.fullName == title));
        });
      },
      onFilterDeselected: (title) {
        setState(() {
          _selectedApplicants.removeWhere((e) => e.fullName == title);
        });
      },
      onFilterSelectionComplete: () {
        widget._filters.applicants.clear();
        widget._filters.applicants.addAll(_selectedApplicants);
        Navigator.pop(context, true);
      },
    );
  }

  void getEmployees() async {
    if (_provider.isLoading) return;

    setState(() => _showMessage = false);
    try {
      var employeeList = await _provider.getNext(searchText: _searchText);
      setState(() {
        _applicants.addAll(employeeList);
        if (_applicants.length == 0) {
          _showMessage = true;
          _message = 'There are no employees to show.';
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
