import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';
import 'package:wallpost/expense_list/services/expense_requests_provider.dart';
import 'package:wallpost/expense_list/ui/view_contracts/expense_list_view.dart';

import '../models/expense_list_item_type.dart';

class ExpenseListPresenter {
  ExpenseListView _view;
  ExpenseRequestsProvider _requestsProvider;
  List<ExpenseRequest> _expenseRequests = [];
  String _errorMessage = "";

  List<ExpenseRequest> get expenseRequests => _expenseRequests;

  ExpenseListPresenter(this._view) : _requestsProvider = ExpenseRequestsProvider();

  ExpenseListPresenter.initWith(
    this._view,
    this._requestsProvider,
  );

  Future getNextExpenses() async {
    _expenseRequests.isEmpty ? _view.showLoader() : _view.updateExpenseList();
    _resetErrors();

    try {
      var expenses = await _requestsProvider.getNext();
      _handleResponse(expenses);
    } on WPException catch (e) {
      setError('${e.userReadableMessage}\n\nTap here to reload.');
    }
  }

  void _handleResponse(List<ExpenseRequest> newListItems) {
    _expenseRequests.addAll(newListItems);

    if (_expenseRequests.isNotEmpty) {
      _view.updateExpenseList();
    } else {
      setError("There are no expense requests to show.\n\nTap here to reload.");
    }
  }

  void setError(String errorMessage) {
    _errorMessage = errorMessage;
    if (_expenseRequests.isEmpty)
      _view.showErrorMessage(errorMessage);
    else
      _view.updateExpenseList();
  }

  void _resetErrors() {
    _errorMessage = "";
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
}
