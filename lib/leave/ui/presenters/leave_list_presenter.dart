import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/services/leave_list_provider.dart';

import '../../entities/leave_list_item.dart';
import '../models/leave_list_item_type.dart';
import '../view_contracts/leave_list_view.dart';

class LeaveListPresenter {
  final LeaveListView _view;
  final LeaveListProvider _leaveListProvider;
  final List<LeaveListItem> _leaveItems = [];
  String _errorMessage = "";
  final filters = LeaveListFilters();

  LeaveListPresenter(this._view) : _leaveListProvider = LeaveListProvider();

  LeaveListPresenter.initWith(this._view, this._leaveListProvider);

  Future<void> getNext() async {
    _leaveItems.isEmpty ? _view.showLoader() : _view.updateLeaveList();
    _resetErrors();

    try {
      var newListItems = await _leaveListProvider.getNext(filters);
      _handleResponse(newListItems);
    } on WPException catch (e) {
      setError('${e.userReadableMessage}\n\nTap here to reload.');
    }
  }

  void _handleResponse(List<LeaveListItem> newListItems) {
    _leaveItems.addAll(newListItems);

    if (_leaveItems.isNotEmpty) {
      _view.updateLeaveList();
    } else {
      setError("There are no leaves to show.\n\nTap here to reload.");
    }
  }

  void setError(String errorMessage) {
    _errorMessage = errorMessage;
    if (_leaveItems.isEmpty)
      _view.showErrorMessage(_errorMessage);
    else
      _view.updateLeaveList();
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_leaveItems.isEmpty) return 0;
    return _leaveItems.length + 1;
  }

  LeaveListItemType getItemTypeAtIndex(int index) {
    if (index < _leaveItems.length) return LeaveListItemType.LeaveListItem;

    if (_errorMessage.isNotEmpty) return LeaveListItemType.ErrorMessage;

    if (_leaveListProvider.isLoading || _leaveListProvider.didReachListEnd == false) return LeaveListItemType.Loader;

    return LeaveListItemType.EmptySpace;
  }

  LeaveListItem getLeaveListItemAtIndex(int index) {
    return _leaveItems[index];
  }

  //MARK: Getters

  String get errorMessage => _errorMessage;
}
