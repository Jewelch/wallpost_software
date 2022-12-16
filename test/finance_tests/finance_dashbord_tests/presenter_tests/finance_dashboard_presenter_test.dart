import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

import '../../../_mocks/mock_company_provider.dart';

class MockFinanceDashBoardProvider extends Mock implements FinanceDashBoardProvider {}

class MockFinanceDashBoardData extends Mock implements FinanceDashBoardData {}

class MockFinanceDashBoardView extends Mock implements FinanceDashBoardView {}

void main() {
  late MockFinanceDashBoardView view;
  late MockFinanceDashBoardProvider provider;
  late MockCompanyProvider companyProvider;
  late FinanceDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(provider);
    verifyNoMoreInteractions(companyProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(provider);
    clearInteractions(companyProvider);
  }

  setUp(() {
    view = MockFinanceDashBoardView();
    provider = MockFinanceDashBoardProvider();
    companyProvider = MockCompanyProvider();
    presenter = FinanceDashboardPresenter.initWith(
      view,
      provider,
      companyProvider,
    );
    _clearInteractionsOnAllMocks();
  });

  test('failure to load the data', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorAndRetryView("Failed to load finance details.\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting filter', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.setFilter(month: 2, year: 2022);

    //then
    expect(presenter.selectedMonth, 2);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: 2, year: 2022),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting month to 0 sets it to null in the provider', () async {
    //given
    when(() => provider.isLoading).thenReturn(false);
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockFinanceDashBoardData()));

    //when
    await presenter.setFilter(month: 0, year: 2022);

    //then
    expect(presenter.selectedMonth, 0);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => provider.isLoading,
      () => view.showLoader(),
      () => provider.get(month: null, year: 2022),
      () => view.onDidLoadFinanceDashBoardData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
