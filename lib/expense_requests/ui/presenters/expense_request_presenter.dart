import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/services/expense_request_executor.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';

class ExpenseRequestPresenter {
  ExpenseRequestsView _view;
  ExpenseRequestExecutor _executor;

  ExpenseRequestPresenter(this._view) : _executor = ExpenseRequestExecutor();

  ExpenseRequestPresenter.initWith(this._view, this._executor);

  Future sendExpenseRequest(ExpenseRequest expenseRequest) async {
    if (!_isExpenseRequestValid(expenseRequest)) return;
    _view.showLoader();
    try {
      var expenseForm = _getExpenseForm(expenseRequest);
      await _executor.execute(expenseForm);
      _view.hideLoader();
      _view.onSendRequestsSuccessfully();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage(e.userReadableMessage);
    }
  }

  bool _isExpenseRequestValid(ExpenseRequest expenseRequest) {
    _view.resetErrors();
    if (expenseRequest.selectedMainCategory == null) {
      _view.notifyMissingMainCategory();
      return false;
    }
    if (expenseRequest.selectedSubCategory == null) {
      _view.notifyMissingSubCategory();
      return false;
    }
    return true;
  }

  ExpenseRequestForm _getExpenseForm(ExpenseRequest expenseRequest) {
    return ExpenseRequestForm(
        parentCategory: expenseRequest.selectedMainCategory!.id,
        category: expenseRequest.selectedSubCategory!.id,
        project: expenseRequest.selectedProject?.id ?? "",
        date: expenseRequest.date.yyyyMMdd2String(),
        description: expenseRequest.description,
        quantity: expenseRequest.quantity.toString(),
        rate: expenseRequest.rate.toString(),
        amount: expenseRequest.amount,
        file: expenseRequest.file,
        total: expenseRequest.total);
  }
}
