import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/services/leave_list_provider.dart';
import 'package:wallpost/leave/ui/views/leave_list/leave_list_tile.dart';

abstract class LeaveListView {
  void reloadData();

  void onLeaveSelected(int index);
}

class LeaveListPresenter {
  final LeaveListView view;
  final LeaveListProvider _leaveListProvider;
  List<LeaveListItem> _leaveLists = [];
  LeaveListFilters _filters = LeaveListFilters();
  String _errorMessage;

  LeaveListPresenter(this.view) : _leaveListProvider = LeaveListProvider();

  Future<void> loadNextListOfLeave() async {
    if (_leaveListProvider.isLoading) return null;
    _resetErrors();
    try {
      var leaveList = await _leaveListProvider.getNext(_filters);
      _leaveLists.addAll(leaveList);
      if (_leaveLists.isEmpty) _errorMessage = 'There are no leaves to show.';
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

//MARK: Functions to get leave list views
  int getNumberOfItems() {
    return _leaveLists.length + 1;
  }

  Widget getLeaveListViewAtIndex(int index) {
    if (index < _leaveLists.length) return _buildLeaveListViewForIndex(index);

    if (_hasErrors()) {
      return _buildErrorView(_errorMessage);
    } else {
      if (_leaveListProvider.didReachListEnd) {
        return Container(height: 200);
      } else {
        return LoaderListTile();
      }
    }
  }

  Widget _buildLeaveListViewForIndex(int index) {
    return LeaveListTile(_leaveLists[index], onLeaveListTileTap: () {
      view.onLeaveSelected(index);
    });
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        loadNextListOfLeave();
        view.reloadData();
      },
    );
  }

  LeaveListItem getLeaveListForIndex(int index) {
    return _leaveLists[index];
  }

  LeaveListFilters getFilters() {
    return _filters;
  }

//MARK: Functions to change the filters
  void updateFilters(LeaveListFilters filters) {
    this._filters = filters;
    reset();
    loadNextListOfLeave();
  }

//MARK: Util functions
  void reset() {
    _leaveListProvider.reset();
    _resetErrors();
    _leaveLists.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
