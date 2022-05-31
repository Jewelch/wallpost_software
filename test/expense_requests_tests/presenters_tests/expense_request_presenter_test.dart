import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/network_failure_exception.dart';
import 'package:wallpost/expense_requests/exeptions/failed_to_save_requet.dart';
import 'package:wallpost/expense_requests/services/expense_categories_provider.dart';
import 'package:wallpost/expense_requests/services/expense_request_creator.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_form_validator.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';
import 'package:wallpost/expense_requests/ui/presenters/expense_request_presenter.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';

import '../_mocks/expense_categories_mock.dart';
import '../_mocks/expense_request_mocks.dart';

class MockExpenseView extends Mock implements ExpenseRequestsView {}

class MockExecutor extends Mock implements ExpenseRequestCreator {}

class MockCategoryProvider extends Mock implements ExpenseCategoriesProvider {}

main() {
  var view = MockExpenseView();
  var executor = MockExecutor();
  var categoryProvider = MockCategoryProvider();
  var presenter = ExpenseRequestPresenter.initWith(view, categoryProvider, executor);

  setUpAll(() {
    registerFallbackValue(getExpenseRequestForm());
    registerFallbackValue(ExpenseRequestFormValidator(ExpenseRequestModel()));
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(categoryProvider);
    verifyNoMoreInteractions(executor);
  }

  test('notify view for update the ui when fetch expense categories successfully', () async {
    when(() => categoryProvider.get()).thenAnswer((_) => Future.value(mockExpenseCategories));

    await presenter.getCategories();

    verifyInOrder([
      view.onStartFetchCategories,
      categoryProvider.get,
      view.onFetchCategoriesSuccessfully,
    ]);
    expect(presenter.expenseRequests.length, 3);
    expect(presenter.expenseRequests, mockExpenseCategories);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('notify view to show error when trying to fetch expense categories throws exception',
      () async {
    presenter = ExpenseRequestPresenter.initWith(view, categoryProvider, executor);
    when(() => categoryProvider.get()).thenAnswer((_) => throw NetworkFailureException());

    await presenter.getCategories();

    verifyInOrder([
      view.onStartFetchCategories,
      categoryProvider.get,
      () => view.onFieldToFetchCategories(NetworkFailureException().userReadableMessage),
    ]);
    expect(presenter.expenseRequests.length, 0);
    expect(presenter.expenseRequests, []);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      'notify view for showing sub categories and project views when select category has sub categories and project',
      () async {
    when(() => categoryProvider.get()).thenAnswer((_) => Future.value(mockExpenseCategories));

    presenter.selectCategory(mockExpenseCategories[2]);

    verify(() => view.showSubCategories(mockExpenseCategories[2].subCategories));
    verify(() => view.showProjects(mockExpenseCategories[2].projects));

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      'notify view for showing sub categories view and hide project view when select category has sub categories only',
      () {
    presenter.selectCategory(mockExpenseCategories[0]);

    verify(() => view.showSubCategories(mockExpenseCategories[0].subCategories));
    verify(() => view.hideProjectsView());
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      'notify view for showing projects view and hide sub categories view when select category has project only',
      () {
    presenter.selectCategory(mockExpenseCategories[1]);

    verify(() => view.showProjects(mockExpenseCategories[1].projects));
    verify(() => view.hideSubCategoriesView());
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("notify view to reset all errors when start sending new expense request", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.selectedMainCategory = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
    ]);
    clearInteractions(view);
    clearInteractions(executor);
  });

  test(
      "validate missing main category when try to send expense request with missed main category value",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.selectedMainCategory = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verify(view.resetErrors);
    var verificationResult = verify(() => view.notifyValidationErrors(captureAny()));
    verificationResult.called(1);
    verificationResult.captured[0].mainCategoryMissingError = "Please select a type";
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "validate missing sub category when try to send expense request with missed sub category value",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.selectedSubCategory = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verify(view.resetErrors);
    var verificationResult = verify(() => view.notifyValidationErrors(captureAny()));
    verificationResult.called(1);
    verificationResult.captured[0].subCategoryMissingError = "Please select a sub type";
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("validate missing project when try to send expense request with missed project value",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.selectedProject = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verify(view.resetErrors);
    var verificationResult = verify(() => view.notifyValidationErrors(captureAny()));
    verificationResult.called(1);
    verificationResult.captured[0].projectMissingError = "Please select a project";
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("validate missing amount when try to send expense request with un valid amount value",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.setAmount("0");

    await presenter.sendExpenseRequest(expenseRequest);

    verify(view.resetErrors);
    var verificationResult = verify(() => view.notifyValidationErrors(captureAny()));
    verificationResult.called(1);
    verificationResult.captured[0].amountMissingError = "Please enter an amount";
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("validate missing quantity when try to send expense request with un valid quantity value",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.setQuantity("0");

    await presenter.sendExpenseRequest(expenseRequest);

    verify(view.resetErrors);
    var verificationResult = verify(() => view.notifyValidationErrors(captureAny()));
    verificationResult.called(1);
    verificationResult.captured[0].quantityMissingError = "Please enter a quantity";
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("validate missing file when try to send expense request with out attchment", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();
    expenseRequest.file = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verify(view.resetErrors);
    var verificationResult = verify(() => view.notifyValidationErrors(captureAny()));
    verificationResult.called(1);
    verificationResult.captured[0].fileMissingError = "Please attach a document";
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("send expense request successfully", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getValidExpenseRequestModel();

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
      view.showLoader,
      () => executor.execute(any()),
      view.hideLoader,
      view.onSendRequestsSuccessfully,
    ]);
  });

  test("send expense request fails and throw exception", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => throw FailedToSaveRequest());
    var expenseRequest = getValidExpenseRequestModel();

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
      view.showLoader,
      () => executor.execute(any()),
      view.hideLoader,
      () => view.showErrorMessage(
          "Failed to upload expense request", FailedToSaveRequest.USER_READABLE_MESSAGE),
    ]);
  });
}
