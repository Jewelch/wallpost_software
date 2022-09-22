import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../entities/leave_approval_list_item.dart';
import '../../services/leave_approval_list_provider.dart';
import '../models/leave_approval_list_item_view_type.dart';
import '../view_contracts/leave_approval_list_view.dart';

class LeaveApprovalListPresenter {
  final LeaveApprovalListView _view;
  final LeaveApprovalListProvider _approvalListProvider;
  final List<LeaveApprovalListItem> _approvalItems = [];
  String _errorMessage = "";
  final String _noItemsMessage = "There are no approvals to show.\n\nTap here to reload.";

  LeaveApprovalListPresenter(String companyId, this._view)
      : _approvalListProvider = LeaveApprovalListProvider(companyId);

  LeaveApprovalListPresenter.initWith(this._view, this._approvalListProvider);

  //MARK: Functions to load data

  Future<void> getNext() async {
    if (_approvalListProvider.isLoading) return;
    _isFirstLoad() ? _view.showLoader() : _view.updateList();
    _resetErrors();

    try {
      var newListItems = await _approvalListProvider.getNext();
      _handleResponse(newListItems);
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _isFirstLoad() ? _view.showErrorMessage() : _view.updateList();
    }
  }

  void _handleResponse(List<LeaveApprovalListItem> newListItems) {
    _approvalItems.addAll(newListItems);
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

  Future<void> refresh() async {
    _approvalItems.clear();
    _approvalListProvider.reset();
    getNext();
  }

  //MARK: Function to select an item

  void selectItem(LeaveApprovalListItem approval) {
    _view.showLeaveDetail(approval);
  }

  //MARK: Function to check isFirstLoad

  bool _isFirstLoad() {
    return _approvalItems.isEmpty;
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_approvalItems.isEmpty) return 0;
    return _approvalItems.length + 1;
  }

  LeaveApprovalListItemViewType getItemTypeAtIndex(int index) {
    if (index < _approvalItems.length) return LeaveApprovalListItemViewType.ListItem;

    if (_errorMessage.isNotEmpty) return LeaveApprovalListItemViewType.ErrorMessage;

    if (_approvalListProvider.isLoading || _approvalListProvider.didReachListEnd == false)
      return LeaveApprovalListItemViewType.Loader;

    return LeaveApprovalListItemViewType.EmptySpace;
  }

  LeaveApprovalListItem getItemAtIndex(int index) {
    return _approvalItems[index];
  }

  //MARK: Functions for successful processing of approval or rejection

  Future<void> onDidProcessApprovalOrRejection(dynamic didProcess, String leaveId) async {
    if (didProcess == true) {
      _approvalItems.removeWhere((approval) => approval.id == leaveId);
      _approvalItems.isEmpty ? await refresh() : _updateList();
    }
  }

  //MARK: Getters

  String getTitle(LeaveApprovalListItem leaveApprovalListItem) {
    return leaveApprovalListItem.applicantName;
  }

  String getTotalDays(LeaveApprovalListItem leaveApprovalListItem) {
    var suffix = leaveApprovalListItem.totalLeaveDays == 1 ? "day" : "days";
    return "${leaveApprovalListItem.totalLeaveDays} $suffix";
  }

  String getLeaveType(LeaveApprovalListItem leaveApprovalListItem) {
    return leaveApprovalListItem.leaveType;
  }

  String getLeaveStartDate(LeaveApprovalListItem leaveApprovalListItem) {
    return leaveApprovalListItem.startDate.toReadableString();
  }

  String getLeaveEndDate(LeaveApprovalListItem leaveApprovalListItem) {
    return leaveApprovalListItem.endDate.toReadableString();
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}
