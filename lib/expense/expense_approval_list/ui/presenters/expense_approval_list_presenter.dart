import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense/expense_approval_list/entities/expense_approval_list_item.dart';

import '../../services/expense_approval_list_provider.dart';
import '../models/expense_approval_list_item_view_type.dart';
import '../view_contracts/expense_approval_list_view.dart';

class ExpenseApprovalListPresenter {
  final ExpenseApprovalListView _view;
  final ExpenseApprovalListProvider _approvalListProvider;
  final List<ExpenseApprovalListItem> _approvalItems = [];
  final List<ExpenseApprovalListItem> _selectedItems = [];
  String _errorMessage = "";
  final String _noItemsMessage = "There are no approvals to show.\n\nTap here to reload.";
  int _numberOfApprovalsProcessed = 0;
  var _isSelectionInProgress = false;

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

  bool _isFirstLoad() {
    return _approvalItems.isEmpty;
  }

  //MARK: Function to refresh the list

  Future<void> refresh() async {
    _approvalItems.clear();
    _selectedItems.clear();
    _approvalListProvider.reset();
    getNext();
  }

  //MARK: Function to show item detail

  void showDetail(ExpenseApprovalListItem approval) {
    _view.showExpenseDetail(approval);
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

  //MARK: Functions to handle multiple item selection

  void initiateMultipleSelection() {
    _isSelectionInProgress = true;
    _view.onDidInitiateMultipleSelection();
    selectAll();
  }

  void endMultipleSelection() {
    _isSelectionInProgress = false;
    _view.onDidEndMultipleSelection();
  }

  void toggleSelection(ExpenseApprovalListItem approvalItem) {
    _selectedItems.contains(approvalItem) ? _selectedItems.remove(approvalItem) : _selectedItems.add(approvalItem);
    _view.updateList();
  }
  bool isAllItemAreSelected() {
    return _selectedItems.length==_approvalItems.length;
  }
  void selectAll() {
    _selectedItems.clear();
    _selectedItems.addAll(_approvalItems);
    _view.updateList();
  }

  void unselectAll() {
    _selectedItems.clear();
    _view.updateList();
  }

  bool isItemSelected(ExpenseApprovalListItem approvalItem) {
    return _selectedItems.contains(approvalItem);
  }

  int getCountOfSelectedItems() {
    return _selectedItems.length;
  }
  int getCountOfAllItems() {
    return _approvalItems.length;
  }

  List<String> getSelectedItemIds() {
    return _selectedItems.map((e) => e.id).toList();
  }

  List<String> getAllIds() {
    return _approvalItems.map((e) => e.id).toList();
  }
  //MARK: Functions for successful processing of approval or rejection

  Future<void> onDidProcessApprovalOrRejection(dynamic didPerformAction, List<String> expenseIds) async {
    if (didPerformAction == true) {
      for (var i = 0; i < expenseIds.length; i++) {
        _numberOfApprovalsProcessed = _numberOfApprovalsProcessed + 1;
        _approvalItems.removeWhere((approval) => approval.id == expenseIds[i]);
      }
      _approvalItems.isNotEmpty ? _updateList() : _view.onDidProcessAllApprovals();
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

  int get numberOfApprovalsProcessed => _numberOfApprovalsProcessed;

  get isSelectionInProgress => _isSelectionInProgress;
}
