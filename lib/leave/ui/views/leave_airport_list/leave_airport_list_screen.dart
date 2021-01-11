import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_airport.dart';
import 'package:wallpost/leave/services/leave_airport_list_provider.dart';

class LeaveAirportListScreen extends StatefulWidget {
  @override
  _LeaveAirportListScreenState createState() => _LeaveAirportListScreenState();
}

class _LeaveAirportListScreenState extends State<LeaveAirportListScreen> {
  final List<LeaveAirport> _leaveAirport = [];
  final LeaveAirportListProvider _provider = LeaveAirportListProvider();
  final _filterListController = MultiSelectFilterListController();

  @override
  void initState() {
    getLeaveAirport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Airports',
      items: [],
      selectedItems: [],
      singleSelection: true,
      searchBarHint: 'Search by airport name',
      noItemsMessage: 'There are no airports to show.',
      controller: _filterListController,
      onRefresh: () {
        _leaveAirport.clear();
        getLeaveAirport();
      },
      onRetry: () {
        getLeaveAirport();
      },
      didReachEndOfList: () {
        //do nothing
      },
      onSearchTextChanged: (_) {
        _leaveAirport.clear();
        getLeaveAirport();
      },
      onFiltersSelectionComplete: () {
        var selectedIndices = _filterListController.getSelectedIndices();
        List<LeaveAirport> selectedLeaveAirport = [];
        for (int index in selectedIndices) {
          selectedLeaveAirport.add(_leaveAirport[index]);
        }
        Navigator.pop(context, selectedLeaveAirport);
      },
    );
  }

  void getLeaveAirport() async {
    if (_provider.isLoading) return;

    try {
      var leaveAirportList = await _provider.getNext(
          searchText: _filterListController.getSearchText());
      _leaveAirport.addAll(leaveAirportList);
      _filterListController
          .addItems(leaveAirportList.map((e) => e.name).toList());
      _filterListController.reachedListEnd();
    } on WPException catch (e) {
      _filterListController.showError(e.userReadableMessage);
    }
  }
}
