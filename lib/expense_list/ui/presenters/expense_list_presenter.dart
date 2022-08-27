import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense__core/entities/expense_request.dart';
import 'package:wallpost/expense__core/entities/expense_request_approval_status.dart';
import 'package:wallpost/expense_list/entities/expense_request_approval_status_filter.dart';
import 'package:wallpost/expense_list/ui/view_contracts/expense_list_view.dart';

import '../../services/expense_list_provider.dart';
import '../models/expense_list_item_type.dart';

class ExpenseListPresenter {
  ExpenseListView _view;
  ExpenseListProvider _requestsProvider;
  List<ExpenseRequest> _expenseRequests = [];
  ExpenseRequestApprovalStatusFilter _selectedStatusFilter = ExpenseRequestApprovalStatusFilter.all;
  String _errorMessage = "";
  final String _noItemsMessage = "There are no expense requests to show.\n\n"
      "Try changing the filters or tap here to reload.";

  ExpenseListPresenter(this._view) : _requestsProvider = ExpenseListProvider();

  ExpenseListPresenter.initWith(this._view, this._requestsProvider);

  Future<void> getNext() async {
    if (_requestsProvider.isLoading) return;
    _isFirstLoad() ? _view.showLoader() : _view.updateList();
    _resetErrors();

    try {
      var expenses = await _requestsProvider.getNext(_selectedStatusFilter);
      _handleResponse(expenses);
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _isFirstLoad() ? _view.showErrorMessage() : _view.updateList();
    }
  }

  void _handleResponse(List<ExpenseRequest> newListItems) {
    _expenseRequests.addAll(newListItems);
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

  //MARK; Function to refresh the list

  Future refresh() async {
    _expenseRequests.clear();
    _requestsProvider.reset();
    await getNext();
  }

  //MARK: Function to select an item

  void selectItem(ExpenseRequest expenseRequest) {
    _view.showExpenseDetail(expenseRequest);
  }

  //MARK: Function to check isFirstLoad

  bool _isFirstLoad() {
    return _expenseRequests.isEmpty;
  }

  //MARK: Function to filter the list

  Future selectApprovalStatusFilterAtIndex(int index) async {
    _selectedStatusFilter = ExpenseRequestApprovalStatusFilter.values[index];
    await refresh();
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_expenseRequests.isEmpty) return 0;
    return _expenseRequests.length + 1;
  }

  ExpenseListItemType getItemTypeAtIndex(int index) {
    if (index < _expenseRequests.length) return ExpenseListItemType.ListItem;

    if (_errorMessage.isNotEmpty) return ExpenseListItemType.ErrorMessage;

    if (_requestsProvider.isLoading || _requestsProvider.didReachListEnd == false) return ExpenseListItemType.Loader;

    return ExpenseListItemType.EmptySpace;
  }

  ExpenseRequest getItemAtIndex(int index) {
    return _expenseRequests[index];
  }

  //MARK: Getters

  String getTitle(ExpenseRequest expenseRequest) {
    return expenseRequest.getTitle();
  }

  String getTotalAmount(ExpenseRequest expenseRequest) {
    return expenseRequest.totalAmount;
  }

  String getRequestNumber(ExpenseRequest expenseRequest) {
    return expenseRequest.requestNumber;
  }

  String getRequestDate(ExpenseRequest expenseRequest) {
    return expenseRequest.requestDate.toReadableString();
  }

  String getRequestedBy(ExpenseRequest expenseRequest) {
    return expenseRequest.requestedBy;
  }

  String getStatus(ExpenseRequest expenseRequest) {
    return expenseRequest.statusMessage ?? "";
  }

  Color getStatusColor(ExpenseRequest expenseRequest) {
    if (expenseRequest.approvalStatus == ExpenseRequestApprovalStatus.pending) {
      return AppColors.yellow;
    } else if (expenseRequest.approvalStatus == ExpenseRequestApprovalStatus.rejected) {
      return AppColors.red;
    } else {
      return AppColors.green;
    }
  }

  List<String> getStatusFilterList() {
    return ExpenseRequestApprovalStatusFilter.values.map((status) => status.toReadableString()).toList();
  }

  String getSelectedStatusFilter() {
    return _selectedStatusFilter.toReadableString();
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}
