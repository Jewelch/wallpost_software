import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense_approval_list/entities/expense_approval_list_item.dart';

import '../../services/expense_approval_list_provider.dart';
import '../models/expense_approval_list_item_view_type.dart';
import '../view_contracts/expense_approval_list_view.dart';

class ExpenseApprovalListPresenter {
  final ExpenseApprovalListView _view;
  final ExpenseApprovalListProvider _approvalListProvider;
  final List<ExpenseApprovalListItem> _approvalItems = [];
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

  void _handleResponse(List<ExpenseApprovalListItem> newListItems) {
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

  void selectItem(ExpenseApprovalListItem approval) {
    _view.showExpenseDetail(approval);
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

  ExpenseApprovalListItem getItemAtIndex(int index) {
    return _approvalItems[index];
  }

  //MARK: Functions for successful processing of approval or rejection

  Future<void> onDidProcessApprovalOrRejection(dynamic didProcess, String expenseId) async {
    if (didProcess == true) {
      _approvalItems.removeWhere((approval) => approval.id == expenseId);
      _approvalItems.isEmpty ? await refresh() : _updateList();
    }
  }

  //MARK: Getters

  String getTitle(ExpenseApprovalListItem approval) {
    return approval.getTitle();
  }

  String getTotalAmount(ExpenseApprovalListItem approval) {
    return approval.totalAmount;
  }

  String getRequestNumber(ExpenseApprovalListItem approval) {
    return approval.requestNumber;
  }

  String getRequestDate(ExpenseApprovalListItem approval) {
    return approval.requestDate.toReadableString();
  }

  String getRequestedBy(ExpenseApprovalListItem approval) {
    return approval.requestedBy;
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}
