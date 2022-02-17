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

  final filters = LeaveListFilters();

  LeaveListPresenter(this._view) : _leaveListProvider = LeaveListProvider();

  LeaveListPresenter.initWith(this._view, this._leaveListProvider);

  Future<void> getNext() async {
    if (_leaveItems.isEmpty) _view.showLoader();

    try {
      var leaveList = await _leaveListProvider.getNext(filters);
      _leaveItems.addAll(leaveList);

      if (_leaveItems.isNotEmpty) {
        _view.showLeaveList();
      } else {
        print("empty!");
        _view.showErrorMessage("There are no leaves to show.\n\nTap here to reload.");
      }
    } on WPException catch (e) {
      print(e.internalErrorMessage);
      _view.showErrorMessage('${e.userReadableMessage}\n\nTap here to reload.');
    }
  }

  int getNumberOfListItems() {
    if (_leaveItems.isEmpty) return 0;

    return _leaveItems.length + 1;
  }

  LeaveListItemType getItemTypeAtIndex(int index) {
    if (index < _leaveItems.length) return LeaveListItemType.LeaveListItem;

    if (_leaveListProvider.isLoading) return LeaveListItemType.Loader;

    if (_leaveListProvider.didReachListEnd) return LeaveListItemType.EmptySpace;

    return LeaveListItemType.ErrorMessage;
  }

  LeaveListItem getLeaveListItemAtIndex(int index) {
    return _leaveItems[index];
  }
}
