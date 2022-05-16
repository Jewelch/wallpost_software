import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';
import 'package:wallpost/expense_list/entities/expense_request_status_filter.dart';
import 'package:wallpost/expense_list/services/expense_request_list_provider.dart';
import 'package:wallpost/expense_list/ui/view_contracts/expense_list_view.dart';

import '../models/expense_list_item_type.dart';

class ExpenseListPresenter {
  ExpenseListView _view;
  ExpenseRequestListProvider _requestsProvider;
  List<ExpenseRequest> _expenseRequests = [];
  String _errorMessage = "";

  List<ExpenseRequest> get expenseRequests => _expenseRequests;
  ExpenseRequestStatusFilter _requestStatusFilter = ExpenseRequestStatusFilter.all;

  ExpenseListPresenter(this._view) : _requestsProvider = ExpenseRequestListProvider();

  ExpenseListPresenter.initWith(this._view, this._requestsProvider);

  Future loadExpenseRequests() async {
    if (_requestsProvider.isLoading) return;

    _expenseRequests.isEmpty ? _view.showLoader() : _view.updateExpenseList();
    _resetErrors();

    try {
      var expenses = await _requestsProvider.getExpenseRequests(_requestStatusFilter);
      _handleResponse(expenses);
    } on WPException catch (e) {
      _setError('${e.userReadableMessage}\n\nTap here to reload.');
    }
  }

  void _handleResponse(List<ExpenseRequest> newListItems) {
    _expenseRequests.addAll(newListItems);

    if (_expenseRequests.isNotEmpty) {
      _view.updateExpenseList();
    } else {
      _setError("There are no expense requests to show.\n\nTap here to reload.");
    }
  }

  void _setError(String errorMessage) {
    _errorMessage = errorMessage;
    if (_expenseRequests.isEmpty)
      _view.showErrorMessage(errorMessage);
    else
      _view.updateExpenseList();
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Function to filter the list

  Future selectFilter(ExpenseRequestStatusFilter filter) async {
    _requestStatusFilter = filter;
    refresh();
  }

  //MARK; Function to refresh the list

  Future refresh() async {
    _expenseRequests.clear();
    _requestsProvider.reset();
    await loadExpenseRequests();
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_expenseRequests.isEmpty) return 0;
    return _expenseRequests.length + 1;
  }

  ExpenseListItemType getItemTypeAtIndex(int index) {
    if (index < _expenseRequests.length) return ExpenseListItemType.ExpenseListItem;

    if (_errorMessage.isNotEmpty) return ExpenseListItemType.ErrorMessage;

    if (_requestsProvider.isLoading || _requestsProvider.didReachListEnd == false)
      return ExpenseListItemType.Loader;

    return ExpenseListItemType.EmptySpace;
  }

  ExpenseRequest getExpenseListItemAtIndex(int index) {
    return _expenseRequests[index];
  }

  //MARK: Getters

  String get errorMessage => _errorMessage;

  List<ExpenseRequestStatusFilter> get expenseRequestsFilters => ExpenseRequestStatusFilter.values;

  ExpenseRequestStatusFilter get selectedStatusFilter => _requestStatusFilter;
}
