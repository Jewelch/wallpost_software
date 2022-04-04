import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/services/expense_categories_provider.dart';
import 'package:wallpost/expense_requests/services/expense_request_executor.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';

class ExpenseRequestPresenter {
  ExpenseRequestsView _view;
  ExpenseCategoriesProvider _categoriesProvider;
  ExpenseRequestExecutor _executor;
  List<ExpenseCategory> _expenseRequests = [];

  List<ExpenseCategory> get expenseRequests => _expenseRequests;

  ExpenseRequestPresenter(this._view)
      : _categoriesProvider = ExpenseCategoriesProvider(),
        _executor = ExpenseRequestExecutor();

  ExpenseRequestPresenter.initWith(
    this._view,
    this._categoriesProvider,
    this._executor,
  );

  //MARK: functions to get categories and select a category

  Future getCategories() async {
    _view.onStartFetchCategories();
    try {
      var categories = await _categoriesProvider.get();
      _expenseRequests.addAll(categories);
      _view.onFetchCategoriesSuccessfully();
    } on WPException catch (e) {
      _view.onFieldToFetchCategories(e.userReadableMessage);
    }
  }

  void selectCategory(ExpenseCategory expenseCategory) {
    if (expenseCategory.subCategories.isNotEmpty) {
      _view.showSubCategories(expenseCategory.subCategories);
    } else {
      _view.hideSubCategoriesView();
    }
    if (expenseCategory.projects.isNotEmpty) {
      _view.showProjects(expenseCategory.projects);
    } else {
      _view.hideProjectsView();
    }
  }

  //MARK: functions to send expense request

  Future sendExpenseRequest(ExpenseRequestModel expenseRequest) async {
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

  bool _isExpenseRequestValid(ExpenseRequestModel expenseRequest) {
    _view.resetErrors();
    if (expenseRequest.selectedMainCategory == null) {
      _view.notifyMissingMainCategory();
      return false;
    }
    if (expenseRequest.selectedSubCategory == null &&
        expenseRequest.selectedMainCategory!.subCategories.isNotEmpty) {
      _view.notifyMissingSubCategory();
      return false;
    }
    if (expenseRequest.selectedProject == null &&
        expenseRequest.selectedMainCategory!.projects.isNotEmpty) {
      _view.notifyMissingProject();
      return false;
    }

    return true;
  }

  ExpenseRequestForm _getExpenseForm(ExpenseRequestModel expenseRequest) {
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
