import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense_approval/entities/expense_approval.dart';

import '../../services/expense_approval_list_provider.dart';
import '../models/expense_approval_list_item_view_type.dart';
import '../view_contracts/expense_approval_list_view.dart';

class ExpenseApprovalListPresenter {
  final ExpenseApprovalListView _view;
  final ExpenseApprovalListProvider _approvalListProvider;
  final List<ExpenseApproval> _approvalItems = [];
  String _errorMessage = "";
  final String _noItemsMessage = "There are no approvals to show.\n\nTap here to reload.";

  ExpenseApprovalListPresenter(String companyId, this._view)
      : _approvalListProvider = ExpenseApprovalListProvider(companyId);

  ExpenseApprovalListPresenter.initWith(this._view, this._approvalListProvider);

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

  void _handleResponse(List<ExpenseApproval> newListItems) {
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

  //MARK: Function to check isFirstLoad

  bool _isFirstLoad() {
    return _approvalItems.isEmpty;
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_approvalItems.isEmpty) return 0;
    return _approvalItems.length + 1;
  }

  ExpenseApprovalListItemViewType getItemTypeAtIndex(int index) {
    if (index < _approvalItems.length) return ExpenseApprovalListItemViewType.ListItem;

    if (_errorMessage.isNotEmpty) return ExpenseApprovalListItemViewType.ErrorMessage;

    if (_approvalListProvider.isLoading || _approvalListProvider.didReachListEnd == false)
      return ExpenseApprovalListItemViewType.Loader;

    return ExpenseApprovalListItemViewType.EmptySpace;
  }

  ExpenseApproval getItemAtIndex(int index) {
    return _approvalItems[index];
  }

  //MARK: Function to remove list item

  Future<void> removeItem(ExpenseApproval approval) async {
    _approvalItems.remove(approval);
    _approvalItems.isEmpty ? await refresh() : _updateList();
  }

  //MARK: Getters

  String getTitle(ExpenseApproval approval) {
    return approval.getTitle();
  }

  String getTotalAmount(ExpenseApproval approval) {
    return approval.totalAmount;
  }

  String getRequestNumber(ExpenseApproval approval) {
    return approval.requestNumber;
  }

  String getRequestDate(ExpenseApproval approval) {
    return approval.requestDate.toReadableString();
  }

  String getRequestedBy(ExpenseApproval approval) {
    return approval.requestedBy;
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}
