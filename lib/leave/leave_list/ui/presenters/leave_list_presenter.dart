import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../leave__core/entities/leave_status.dart';
import '../../entities/leave_list_item.dart';
import '../../entities/leave_list_status_filter.dart';
import '../../services/leave_list_provider.dart';
import '../models/leave_list_item_view_type.dart';
import '../view_contracts/leave_list_view.dart';

class LeaveListPresenter {
  LeaveListView _view;
  LeaveListProvider _requestsProvider;
  List<LeaveListItem> _leaves = [];
  var _selectedStatusFilter = LeaveListStatusFilter.all;
  String _errorMessage = "";
  final String _noItemsMessage = "There are no leave requests to show.\n\n"
      "Try changing the filters or tap here to reload.";

  LeaveListPresenter(this._view) : _requestsProvider = LeaveListProvider();

  LeaveListPresenter.initWith(this._view, this._requestsProvider);

  Future<void> getNext() async {
    if (_requestsProvider.isLoading) return;
    _isFirstLoad() ? _view.showLoader() : _view.updateList();
    _resetErrors();

    try {
      var leaves = await _requestsProvider.getNext(_selectedStatusFilter);
      _handleResponse(leaves);
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _isFirstLoad() ? _view.showErrorMessage() : _view.updateList();
    }
  }

  void _handleResponse(List<LeaveListItem> newListItems) {
    _leaves.addAll(newListItems);
    _updateList();
  }

  void _updateList() {
    if (_isFirstLoad()) {
      _view.showNoItemsMessage();
    } else {
      _view.updateList();
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Function to refresh the list

  Future refresh() async {
    _leaves.clear();
    _requestsProvider.reset();
    await getNext();
  }

  //MARK: Function to select an item

  void selectItem(LeaveListItem leaveListItem) {
    _view.showLeaveDetail(leaveListItem);
  }

  //MARK: Function to check isFirstLoad

  bool _isFirstLoad() {
    return _leaves.isEmpty;
  }

  //MARK: Function to filter the list

  Future selectStatusFilterAtIndex(int index) async {
    _selectedStatusFilter = LeaveListStatusFilter.values[index];
    await refresh();
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_leaves.isEmpty) return 0;
    return _leaves.length + 1;
  }

  LeaveListItemViewType getItemTypeAtIndex(int index) {
    if (index < _leaves.length) return LeaveListItemViewType.ListItem;

    if (_errorMessage.isNotEmpty) return LeaveListItemViewType.ErrorMessage;

    if (_requestsProvider.isLoading || _requestsProvider.didReachListEnd == false) return LeaveListItemViewType.Loader;

    return LeaveListItemViewType.EmptySpace;
  }

  LeaveListItem getItemAtIndex(int index) {
    return _leaves[index];
  }

  //MARK: Getters

  String getTitle(LeaveListItem leaveListItem) {
    return leaveListItem.leaveType;
  }

  String getStartDate(LeaveListItem leaveListItem) {
    return leaveListItem.startDate.toReadableString();
  }

  String getEndDate(LeaveListItem leaveListItem) {
    return leaveListItem.endDate.toReadableString();
  }

  String getTotalLeaveDays(LeaveListItem leaveListItem) {
    return "${leaveListItem.totalLeaveDays} Days";
  }

  String? getStatus(LeaveListItem leaveListItem) {
    if (leaveListItem.status == LeaveStatus.approved) return null;

    return leaveListItem.status.toReadableString();
  }

  Color getStatusColor(LeaveListItem leaveListItem) {
    if (leaveListItem.status == LeaveStatus.pendingApproval) {
      return AppColors.yellow;
    } else {
      return AppColors.red;
    }
  }

  List<String> getStatusFilterList() {
    return LeaveListStatusFilter.values.map((status) => status.toReadableString()).toList();
  }

  String getSelectedStatusFilter() {
    return _selectedStatusFilter.toReadableString();
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}
