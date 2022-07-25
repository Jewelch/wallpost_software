import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval_status.dart';
import 'package:wallpost/leave_approvals/services/leave_approval_list_provider.dart';

import '../models/leave_approval_list_view_type.dart';
import '../view_contracts/leave_approval_list_view.dart';

class LeaveApprovalListPresenter {
  final LeaveApprovalListView _view;
  final LeaveApprovalListProvider _leaveApprovalListProvider;
  final List<LeaveApproval> _leaveItems = [];
  String _errorMessage = "";
  final approvalStatus = LeaveApprovalStatus.all;

  LeaveApprovalListPresenter(this._view) : _leaveApprovalListProvider = LeaveApprovalListProvider();

  LeaveApprovalListPresenter.initWith(this._view, this._leaveApprovalListProvider);

  Future<void> getNext() async {
    _leaveItems.isEmpty ? _view.showLoader() : _view.updateLeaveList();
    _resetErrors();

    try {
      var newListItems = await _leaveApprovalListProvider.getNext(approvalStatus);
      _handleResponse(newListItems);
    } on WPException catch (e) {
      setError('${e.userReadableMessage}\n\nTap here to reload.');
    }
  }

  void _handleResponse(List<LeaveApproval> newListItems) {
    _leaveItems.addAll(newListItems);

    if (_leaveItems.isNotEmpty) {
      _view.updateLeaveList();
    } else {
      setError("There are no leave approvals to show.\n\nTap here to reload.");
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

  LeaveApprovalListViewType getItemTypeAtIndex(int index) {
    if (index < _leaveItems.length) return LeaveApprovalListViewType.List;

    if (_errorMessage.isNotEmpty) return LeaveApprovalListViewType.ErrorMessage;

    if (_leaveApprovalListProvider.isLoading || _leaveApprovalListProvider.didReachListEnd == false)
      return LeaveApprovalListViewType.Loader;

    return LeaveApprovalListViewType.EmptySpace;
  }

  LeaveApproval getItemAtIndex(int index) {
    return _leaveItems[index];
  }

  //MARK: Getters

  String get errorMessage => _errorMessage;
}
