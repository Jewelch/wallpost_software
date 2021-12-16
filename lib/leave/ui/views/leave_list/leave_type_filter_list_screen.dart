// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_type.dart';
import 'package:wallpost/leave/services/leave_types_provider.dart';

class LeaveTypeFilterListScreen extends StatefulWidget {
  @override
  _LeaveTypeFilterListScreenState createState() => _LeaveTypeFilterListScreenState();
}

class _LeaveTypeFilterListScreenState extends State<LeaveTypeFilterListScreen> {
  final List<LeaveType> _leaveTypes = [];
  final LeaveTypesProvider _provider = LeaveTypesProvider();
//  final _filterListController = MultiSelectFilterListController();

  @override
  void initState() {
    getLeaveTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Leave Type',
      items: [],
      selectedItems: [],
      singleSelection: true,
      hideSearchBar: true,
//      noItemsMessage: 'There are no leave types to show.',
//      controller: _filterListController,
      onRefresh: () {
        _leaveTypes.clear();
        getLeaveTypes();
      },
      onRetry: () {
        getLeaveTypes();
      },
      didReachEndOfList: () {
        //do nothing
      },
      onSearchTextChanged: (_) {
        _leaveTypes.clear();
        getLeaveTypes();
      },
//      onFiltersSelectionComplete: () {
//        var selectedIndices = _filterListController.getSelectedIndices();
//        List<LeaveType> selectedLeaveTypes = [];
//        for (int index in selectedIndices) {
//          selectedLeaveTypes.add(_leaveTypes[index]);
//        }
//        Navigator.pop(context, selectedLeaveTypes);
//      },
    );
  }

  void getLeaveTypes() async {
    if (_provider.isLoading) return;

    try {
      var leaveTypeList = await _provider.getLeaveTypes();
      _leaveTypes.addAll(leaveTypeList);
//      _filterListController.addItems(leaveTypeList.map((e) => e.name).toList());
//      _filterListController.reachedListEnd();
    } on WPException catch (e) {
//      _filterListController.showError(e.userReadableMessage);
    }
  }
}
