import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/aggregated_sales_data_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/sales_breakdowns_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/restaurant_dashboard_presenter.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/view_contracts/restaurant_dashboard_view.dart';

import '../../mocks.dart';

class MockSalesDataProvider extends Mock implements AggregatedSalesDataProvider {}

class MockSalesDataView extends Mock implements RestaurantDashboardView {}

class MockSalesBreakDownProvider extends Mock implements SalesBreakDownsProvider {}

class MockSalesBreakDowns extends Mock implements SalesBreakDownItem {}

void main() {
  var salesDataProvider = MockSalesDataProvider();
  var salesBreakDownProvider = MockSalesBreakDownProvider();
  var view = MockSalesDataView();
  var dateFilter = DateRangeFilters();
  var salesPresenter =
      RestaurantDashboardPresenter.initWith(view, salesDataProvider, salesBreakDownProvider, dateFilter);

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(salesDataProvider);
    verifyNoMoreInteractions(salesBreakDownProvider);
  }

  setUpAll(() {
    registerFallbackValue(SalesBreakDownWiseOptions.basedOnOrder);
  });

  // MARK: Test Loading Aggregated Sales Data

  test('loading sales data when sales data provider is loading does nothing', () async {
    //given
    when(() => salesDataProvider.isLoading).thenReturn(true);

    //when
    await salesPresenter.loadSalesData();

    //then
    verify(() => salesDataProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load sales data', () async {
    //given
    when(() => salesDataProvider.isLoading).thenReturn(false);
    when(() => salesDataProvider.getSalesAmounts(dateFilter))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await salesPresenter.loadSalesData();

    verifyInOrder([
      () => salesDataProvider.isLoading,
      () => view.showLoader(),
      () => salesDataProvider.getSalesAmounts(dateFilter),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading sales data', () async {
    //given
    var salesData = MockSalesData();
    when(() => salesDataProvider.isLoading).thenReturn(false);
    when(() => salesDataProvider.getSalesAmounts(dateFilter)).thenAnswer((_) => Future.value(salesData));

    //when
    await salesPresenter.loadSalesData();

    //then
    verifyInOrder([
      () => salesDataProvider.isLoading,
      () => view.showLoader(),
      () => salesDataProvider.getSalesAmounts(dateFilter),
      () => view.showSalesData(salesData),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // MARK: Test changing sales breakdown wise

  test('change selected sales breakdown wise successfully', () {
    //when
    salesPresenter.selectSalesBreakDownWiseAtIndex(SalesBreakDownWiseOptions.basedOnMenu.index);

    //then
    expect(salesPresenter.selectedBreakDownWise, SalesBreakDownWiseOptions.basedOnMenu);
    verify(() => view.onDidSelectSalesBreakdownFilteringStrategy());
  });

  // MARK: Test Loading sales breakdown wise

  test('loading sales breakdowns when sales breakdowns provider is loading does nothing', () async {
    //given
    when(() => salesBreakDownProvider.isLoading).thenReturn(true);

    //when
    await salesPresenter.loadSalesBreakDown();

    //then
    verify(() => salesBreakDownProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load sales breakdowns', () async {
    //given
    when(() => salesBreakDownProvider.isLoading).thenReturn(false);
    when(() => salesBreakDownProvider.getSalesBreakDowns(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await salesPresenter.loadSalesBreakDown();

    verifyInOrder([
      () => salesBreakDownProvider.isLoading,
      () => view.showLoader(),
      () => salesBreakDownProvider.getSalesBreakDowns(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading sales breakdowns', () async {
    //given
    var salesBreakDowns = [MockSalesBreakDowns()];
    when(() => salesBreakDownProvider.isLoading).thenReturn(false);
    when(() => salesBreakDownProvider.getSalesBreakDowns(any())).thenAnswer((_) => Future.value(salesBreakDowns));

    //when
    await salesPresenter.loadSalesBreakDown();

    //then
    verifyInOrder([
      () => salesBreakDownProvider.isLoading,
      () => view.showLoader(),
      () => salesBreakDownProvider.getSalesBreakDowns(any()),
      () => view.showSalesBreakDowns(salesBreakDowns),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
