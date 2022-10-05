import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense/expense__core/entities/expense_request.dart';
import 'package:wallpost/expense/expense__core/entities/expense_request_approval_status.dart';
import 'package:wallpost/expense/expense_detail/services/expense_detail_provider.dart';
import 'package:wallpost/expense/expense_detail/ui/presenters/expense_detail_presenter.dart';
import 'package:wallpost/expense/expense_detail/ui/view_contracts/expense_detail_view.dart';

import '../../../_mocks/mock_network_adapter.dart';

class MockExpenseDetailView extends Mock implements ExpenseDetailView {}

class MockExpenseDetailProvider extends Mock implements ExpenseDetailProvider {}

class MockExpenseRequest extends Mock implements ExpenseRequest {}

void main() {
  late MockExpenseDetailView view;
  late MockExpenseDetailProvider detailProvider;
  late ExpenseDetailPresenter presenter;

  setUp(() {
    view = MockExpenseDetailView();
    detailProvider = MockExpenseDetailProvider();
    presenter = ExpenseDetailPresenter.initWith("someCompanyId", "someExpenseId", view, detailProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(detailProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(detailProvider);
  }

  test('does nothing when the provider is loading', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadDetail();

    //then
    verifyInOrder([
      () => detailProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load detail', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadDetail();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => detailProvider.isLoading,
      () => view.showLoader(),
      () => detailProvider.get("someExpenseId"),
      () => view.onDidFailToLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('loading detail successfully', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockExpenseRequest()));

    //when
    await presenter.loadDetail();

    //then
    verifyInOrder([
      () => detailProvider.isLoading,
      () => view.showLoader(),
      () => detailProvider.get("someExpenseId"),
      () => view.onDidLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('error is reset on reload', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadDetail();
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockExpenseRequest()));

    //when
    await presenter.loadDetail();

    //then
    expect(presenter.errorMessage, null);
  });

  //MARK: Tests for approval and rejection

  test("initiating approval", () async {
    //given
    var expenseRequest = MockExpenseRequest();
    when(() => expenseRequest.requestedBy).thenReturn("some name");
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expenseRequest));
    await presenter.loadDetail();
    _clearAllInteractions();

    //when
    presenter.initiateApproval();

    //then
    verifyInOrder([
      () => view.processApproval("someCompanyId", "someExpenseId", "some name"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("initiating rejection", () async {
    //given
    var expenseRequest = MockExpenseRequest();
    when(() => expenseRequest.requestedBy).thenReturn("some name");
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expenseRequest));
    await presenter.loadDetail();
    _clearAllInteractions();

    //when
    presenter.initiateRejection();

    //then
    verifyInOrder([
      () => view.processRejection("someCompanyId", "someExpenseId", "some name"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for getters

  test('should not show approval actions when not coming from approvals list', () async {
    presenter = ExpenseDetailPresenter.initWith(
      "someCompanyId",
      "someExpenseId",
      view,
      detailProvider,
      didLaunchDetailScreenForApproval: false,
    );

    expect(presenter.shouldShowApprovalActions(), false);
  });

  test(
      'should not show approval actions when coming from approvals list'
      'but the approval status is not pending', () async {
    presenter = ExpenseDetailPresenter.initWith(
      "someCompanyId",
      "someExpenseId",
      view,
      detailProvider,
      didLaunchDetailScreenForApproval: true,
    );
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.approved);
    await presenter.loadDetail();

    expect(presenter.shouldShowApprovalActions(), false);
  });

  test(
      'should show approval actions when coming from approvals list'
      'and the approval status is not pending', () async {
    presenter = ExpenseDetailPresenter.initWith(
      "someCompanyId",
      "someExpenseId",
      view,
      detailProvider,
      didLaunchDetailScreenForApproval: true,
    );
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.pending);
    await presenter.loadDetail();

    expect(presenter.shouldShowApprovalActions(), true);
  });

  test('get title', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.getTitle()).thenReturn("Some Title");
    await presenter.loadDetail();

    expect(presenter.getTitle(), "Some Title");
  });

  test('get request number', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.requestNumber).thenReturn("Some Request Number");
    await presenter.loadDetail();

    expect(presenter.getRequestNumber(), "Some Request Number");
  });

  test('get request date', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.requestDate).thenReturn(DateTime(2022, 8, 20));
    await presenter.loadDetail();

    expect(presenter.getRequestDate(), "20 Aug 2022");
  });

  test('get requested by', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.requestedBy).thenReturn("Some Name");
    await presenter.loadDetail();

    expect(presenter.getRequestedBy(), "Some Name");
  });

  test('get main category', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.mainCategory).thenReturn("main category");
    await presenter.loadDetail();

    expect(presenter.getMainCategory(), "main category");
  });

  test('get project', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.project).thenReturn("some project");
    await presenter.loadDetail();

    expect(presenter.getProject(), "some project");
  });

  test('get sub category', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.subCategory).thenReturn("sub category");
    await presenter.loadDetail();

    expect(presenter.getSubCategory(), "sub category");
  });

  test('get rate', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.rate).thenReturn("USD 20.40");
    await presenter.loadDetail();

    expect(presenter.getRate(), "USD 20.40");
  });

  test('get quantity', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.quantity).thenReturn(12);
    await presenter.loadDetail();

    expect(presenter.getQuantity(), "12");
  });

  test('get total amount', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.totalAmount).thenReturn("USD 34.50");
    await presenter.loadDetail();

    expect(presenter.getTotalAmount(), "USD 34.50");
  });

  test('get attachment url', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.attachmentUrl).thenReturn("attachment url");
    await presenter.loadDetail();

    expect(presenter.getAttachmentUrl(), "attachment url");
  });

  test("get status", () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.statusMessage).thenReturn("some status message");
    await presenter.loadDetail();

    expect(presenter.getStatus(), "some status message");
  });

  test("get status color", () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    await presenter.loadDetail();

    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.pending);
    expect(presenter.getStatusColor(), AppColors.yellow);

    //rejected
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.rejected);
    expect(presenter.getStatusColor(), AppColors.red);

    //approved
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.approved);
    expect(presenter.getStatusColor(), AppColors.green);
  });

  test('get rejection reason', () async {
    var expense = MockExpenseRequest();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(expense));
    when(() => expense.rejectionReason).thenReturn("some rejection reason");
    await presenter.loadDetail();

    expect(presenter.getRejectionReason(), "some rejection reason");
  });
}
