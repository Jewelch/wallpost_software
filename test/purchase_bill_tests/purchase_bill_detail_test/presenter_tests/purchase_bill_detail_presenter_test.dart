import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_expenses.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/services/purchase_bill_detail_provider.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/presenters/purchase_bill_detail_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/view_contracts/purchase_bill_detail_view.dart';

import '../../../_mocks/mock_network_adapter.dart';

class MockPurchaseBillDetailView extends Mock implements PurchaseBillDetailView {}

class MockPurchaseBillDetailProvider extends Mock implements PurchaseBillDetailProvider {}

class MockPurchaseBillDetail extends Mock implements PurchaseBillDetail {}

class MockPurchaseBillDetailItem extends Mock implements PurchaseBillDetailItem {}

class MockPurchaseBillDetailExpenses extends Mock implements PurchaseBillDetailExpenses {}

void main() {
  late MockPurchaseBillDetailView view;
  late MockPurchaseBillDetailProvider detailProvider;
  late PurchaseBillDetailPresenter presenter;

  setUp(() {
    view = MockPurchaseBillDetailView();
    detailProvider = MockPurchaseBillDetailProvider();
    presenter = PurchaseBillDetailPresenter.initWith("someCompanyId", "someBillId", view, detailProvider);
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
      () => detailProvider.get("someBillId"),
      () => view.onDidFailToLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('loading detail successfully', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockPurchaseBillDetail()));

    //when
    await presenter.loadDetail();

    //then
    verifyInOrder([
      () => detailProvider.isLoading,
      () => view.showLoader(),
      () => detailProvider.get("someBillId"),
      () => view.onDidLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('error is reset on reload', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadDetail();
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockPurchaseBillDetail()));

    //when
    await presenter.loadDetail();

    //then
    expect(presenter.errorMessage, null);
  });

  //MARK: Tests for approval and rejection

  test("initiating approval", () async {
    //given
    var billDetailData = MockPurchaseBillDetail();
    when(() => billDetailData.billTo).thenReturn("some name");
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetailData));
    await presenter.loadDetail();
    _clearAllInteractions();

    //when
    presenter.initiateApproval();

    //then
    verifyInOrder([
      () => view.processApproval("someCompanyId", "someBillId", "some name"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  //
  test("initiating rejection", () async {
    //given
    var billDetail = MockPurchaseBillDetail();
    when(() => billDetail.billTo).thenReturn("some name");
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    await presenter.loadDetail();
    _clearAllInteractions();

    //when
    presenter.initiateRejection();

    //then
    verifyInOrder([
      () => view.processRejection("someCompanyId", "someBillId", "some name"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for getters

  test('get supplier name', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.billTo).thenReturn("test supplier");
    await presenter.loadDetail();

    expect(presenter.getSupplierName(), "test supplier");
  });

  test('get bill Number', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.billNumber).thenReturn("22/00089");
    await presenter.loadDetail();

    expect(presenter.getBillNumber(), "22/00089");
  });

  test('get due date', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.dueDate).thenReturn(DateTime(2022, 08, 20));
    await presenter.loadDetail();

    expect(presenter.getDueDate(), "20-Aug-2022");
  });

  test('get currency', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.currency).thenReturn("INR");
    await presenter.loadDetail();

    expect(presenter.getCurrency(), "INR");
  });

  test('get sub total', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.subTotal).thenReturn("300.00");
    await presenter.loadDetail();

    expect(presenter.getSubTotal(), "300.00");
  });

  test('get total discount', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.totalDiscount).thenReturn("4.00");
    await presenter.loadDetail();

    expect(presenter.getDiscount(), "4.00");
  });

  test('get grand total tax', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.totalTax).thenReturn("40");
    await presenter.loadDetail();

    expect(presenter.getTax(), "40");
  });

  test('get grand total', () async {
    var billDetail = MockPurchaseBillDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.total).thenReturn("400.00");
    await presenter.loadDetail();

    expect(presenter.getTotal(), "400.00");
  });

  test('get number of list items', () async {
    //when
    var billDetail = MockPurchaseBillDetail();
    var billDetailItem1 = MockPurchaseBillDetailItem();
    var billDetailItem2 = MockPurchaseBillDetailItem();
    var billDetailItem3 = MockPurchaseBillDetailItem();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.billDetailItem).thenReturn([billDetailItem1, billDetailItem2, billDetailItem3]);
    await presenter.loadDetail();
    when(() => detailProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 3);
  });

  test('get number of expense list items', () async {
    //when
    var billDetail = MockPurchaseBillDetail();
    var billDetailExpense1 = MockPurchaseBillDetailExpenses();
    var billDetailExpense2 = MockPurchaseBillDetailExpenses();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.billDetailExpenseItem).thenReturn([billDetailExpense1, billDetailExpense2]);
    await presenter.loadDetail();
    when(() => detailProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfExpensesListItems(), 2);
  });

  test('getting list item at index', () async {
    //when
    var billDetail = MockPurchaseBillDetail();
    var billDetailItem1 = MockPurchaseBillDetailItem();
    var billDetailItem2 = MockPurchaseBillDetailItem();
    var billDetailItem3 = MockPurchaseBillDetailItem();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.billDetailItem).thenReturn([billDetailItem1, billDetailItem2, billDetailItem3]);
    await presenter.loadDetail();
    when(() => detailProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getItemAtIndex(0), billDetailItem1);
    expect(presenter.getItemAtIndex(1), billDetailItem2);
    expect(presenter.getItemAtIndex(2), billDetailItem3);
  });

  test('getting expense list item at index', () async {
    //when
    var billDetail = MockPurchaseBillDetail();
    var billDetailExpense1 = MockPurchaseBillDetailExpenses();
    var billDetailExpense2 = MockPurchaseBillDetailExpenses();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(billDetail));
    when(() => billDetail.billDetailExpenseItem).thenReturn([billDetailExpense1, billDetailExpense2]);
    await presenter.loadDetail();
    when(() => detailProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getExpensesItemAtIndex(0), billDetailExpense1);
    expect(presenter.getExpensesItemAtIndex(1), billDetailExpense2);
  });
}
