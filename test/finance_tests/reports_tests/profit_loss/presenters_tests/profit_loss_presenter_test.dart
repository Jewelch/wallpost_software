import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/reports/profit_loss/entities/profit_loss_model.dart';
import 'package:wallpost/finance/reports/profit_loss/entities/profit_loss_report_filters.dart';
import 'package:wallpost/finance/reports/profit_loss/services/profit_loss_provider.dart';
import 'package:wallpost/finance/reports/profit_loss/ui/presenter/profit_loss_presenter.dart';
import 'package:wallpost/finance/reports/profit_loss/ui/view_contracts/profit_loss_view.dart';

import '../../../../_mocks/mock_company_provider.dart';
import '../mocks.dart';
import 'helpers.dart';

class MockProfitLossReportProvider extends Mock implements ProfitsLossesProvider {}

class MockProfitLossReport extends Mock implements ProfitsLossesReport {}

class MockProfitLossView extends Mock implements ProfitsLossesView {}

void main() {
  var profitLossReportProvider = MockProfitLossReportProvider();
  var view = MockProfitLossView();
  var dateFilter = DateRange();
  late ProfitsLossesPresenter presenter;

  void _initializePresenter() {
    presenter = ProfitsLossesPresenter.initWith(
      view,
      profitLossReportProvider,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(profitLossReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(profitLossReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockProfitLossReport());
    registerFallbackValue(dateFilter);
  });

  test('loading profit loss report when the provider is loading does nothing', () async {
    //given
    when(() => profitLossReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadProfitsLossesData();

    //then
    verify(() => profitLossReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load profit loss report', () async {
    //given
    when(() => profitLossReportProvider.isLoading).thenReturn(false);
    when(() => profitLossReportProvider.getProfitsLosses(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadProfitsLossesData();

    verifyInOrder([
      () => profitLossReportProvider.isLoading,
      () => view.showLoader(),
      () => profitLossReportProvider.getProfitsLosses(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('successfully loading the profit loss report', () async {
    //given
    var report = MockProfitLossReport();
    when(() => profitLossReportProvider.isLoading).thenReturn(false);
    when(() => profitLossReportProvider.getProfitsLosses(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadProfitsLossesData();

    verifyInOrder([
      () => profitLossReportProvider.isLoading,
      () => view.showLoader(),
      () => profitLossReportProvider.getProfitsLosses(any()),
      () => view.onDidLoadReport(),
    ]);
    _clearInteractionsOnAllMocks();
  });

  test('on filter got clicked notify ui to show filters', () {
    //when
    presenter.onFiltersGotClicked();

    //then
    verify(view.showFilter);
  });

  test("apply Filter do nothing when new applied filters is null", () async {
    //given
    var newFilters;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter do nothing when there is no different between the current filters and the new one", () async {
    //given
    var newFilters = ProfitsLossesReportFilters();
    newFilters.dateFilters = presenter.filters.dateFilters;

    //when
    await presenter.applyFilters(newFilters);

    //then
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("apply Filter when only the change happened to the date filters call the api to load the profit loss from api",
      () async {
    //given
    var profitLossData = ProfitsLossesReport.fromJson(Mocks.profitLossReportResponse);
    when(() => profitLossReportProvider.isLoading).thenReturn(false);
    when(() => profitLossReportProvider.getProfitsLosses(any())).thenAnswer((_) => Future.value(profitLossData));
    var newFilters = ProfitsLossesReportFilters();
    newFilters.dateFilters = getDifferentDateRangeOption(presenter.filters.dateFilters);

    //when
    await presenter.applyFilters(newFilters);

    //then
    verifyInOrder([
      () => profitLossReportProvider.isLoading,
      () => view.showLoader(),
      () => profitLossReportProvider.getProfitsLosses(any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("reset filter return the filters to the default state and call the api", () async {
    // given
    var report = MockProfitLossReport();
    when(() => profitLossReportProvider.isLoading).thenReturn(false);
    when(() => profitLossReportProvider.getProfitsLosses(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.resetFilters();

    //then
    verifyInOrder([
      () => profitLossReportProvider.isLoading,
      () => view.showLoader(),
      () => profitLossReportProvider.getProfitsLosses(any()),
      () => view.onDidLoadReport(),
    ]);
    expect(presenter.filters.dateFilters.selectedRangeOption, SelectableDateRangeOptions.thisYear);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
