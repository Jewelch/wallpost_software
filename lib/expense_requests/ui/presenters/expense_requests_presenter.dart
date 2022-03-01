import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/exeptions/missing_expense_request_data.dart';
import 'package:wallpost/expense_requests/services/expense_request_executor.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/per_expense_request_view.dart';

class ExpenseRequestsPresenter {
  ExpenseRequestsView _view;
  ExpenseRequestExecutor _requestExecutor;

  ExpenseRequestsPresenter(this._view) : _requestExecutor = ExpenseRequestExecutor();

  ExpenseRequestsPresenter.initWith(this._view, this._requestExecutor);

  Future sendExpenseRequests(List<PerExpenseRequestView> requestsViews) async {
    _view.showLoader();
    try {
      var requests = _getExpenseRequestsFromViews(requestsViews);
      await _requestExecutor.execute(requests);
      _view.hideLoader();
      _view.onSendRequestsSuccessfully();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage(e.userReadableMessage);
    }
  }

  List<ExpenseRequestForm> _getExpenseRequestsFromViews(List<PerExpenseRequestView> views) {
    List<ExpenseRequestForm> requests = [];
    views.forEach((requestsView) {
      var request = requestsView.getExpenseRequest();
      if (request == null) throw MissingExpenseRequestData();
      requests.add(request);
    });
    return requests;
  }
}



//UI model expense_request - attributes will be set one by one

//entity model expense_request - attributes are required at the time of initialization