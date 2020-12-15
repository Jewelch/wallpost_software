import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/services/leave_list_provider.dart';
import 'package:wallpost/leave/ui/views/leave_list/leave_list_tile.dart';

abstract class LeaveListView {
  void reloadData();
}

class LeaveListPresenter {
  final LeaveListView view;
  final LeaveListProvider provider;
  List<LeaveListItem> _leaveLists = [];
  String _errorMessage;

  LeaveListPresenter(this.view) : provider = LeaveListProvider();

  LeaveListPresenter.initWith(this.view, this.provider);

  Future<void> loadNextListOfLeave() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    view.reloadData();
    try {
      var leaveList = await provider.getNext();
      _leaveLists.addAll(leaveList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return _leaveLists.length + 1;

    if (_leaveLists.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return _leaveLists.length;
    } else {
      return _leaveLists.length + 1;
    }
  }

  Widget getViewAtIndex(int index) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile(
        '$_errorMessage \nTap here to reload.',
        onTap: () {
          loadNextListOfLeave();
          view.reloadData();
        },
      );

    if (_leaveLists.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < _leaveLists.length) {
      return LeaveListTile(_leaveLists[index]);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == _leaveLists.length;
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (provider.didReachListEnd) {
      return ErrorListTile(
        'There are no leaves to show. \nTap here to reload.',
        onTap: () {
          reset();
          loadNextListOfLeave();
          view.reloadData();
        },
      );
    } else {
      return LoaderListTile();
    }
  }

//MARK: Util functions
  void reset() {
    provider.reset();
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
