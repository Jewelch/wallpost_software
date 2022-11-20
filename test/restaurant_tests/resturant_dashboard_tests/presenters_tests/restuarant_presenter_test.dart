import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/models/performance_value.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/aggregated_sales_data_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/sales_breakdowns_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/restaurant_dashboard_presenter.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/view_contracts/restaurant_dashboard_view.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_current_user_provider.dart';
import '../../mocks.dart';

class MockSalesDataProvider extends Mock implements AggregatedSalesDataProvider {}

class MockSalesDataView extends Mock implements RestaurantDashboardView {}

class MockSalesBreakDownProvider extends Mock implements SalesBreakDownsProvider {}

class MockAggregatedSalesData extends Mock implements AggregatedSalesData {}

class MockSalesBreakDowns extends Mock implements SalesBreakDownItem {}

void main() {
  var salesDataProvider = MockSalesDataProvider();
  var salesBreakDownProvider = MockSalesBreakDownProvider();
  var view = MockSalesDataView();
  var dateFilter = DateRangeFilters();
  var salesPresenter = RestaurantDashboardPresenter.initWith(
    view,
    salesDataProvider,
    salesBreakDownProvider,
    dateFilter,
    MockCurrentUserProvider(),
    MockCompanyProvider(),
  );

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(salesDataProvider);
    verifyNoMoreInteractions(salesBreakDownProvider);
  }

  setUpAll(() {
    registerFallbackValue(SalesBreakDownWiseOptions.basedOnOrder);
  });

  _sortSalesDataItems() => Mocks.salesBreakDownsItems
    ..sort(
      (a, b) => b.totalSales.toDouble.compareTo(a.totalSales.toDouble),
    );

  // MARK: Test Loading Aggregated Sales Data

  test('loading sales data when sales data provider is loading does nothing', () async {
    //given
    when(() => salesDataProvider.isLoading).thenReturn(true);

    //when
    await salesPresenter.loadAggregatedSalesData();

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
    await salesPresenter.loadAggregatedSalesData();

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
    await salesPresenter.loadAggregatedSalesData();

    //then
    verifyInOrder([
      () => salesDataProvider.isLoading,
      () => view.showLoader(),
      () => salesDataProvider.getSalesAmounts(dateFilter),
      () => view.updateSalesData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // MARK: Test changing sales breakdown wise

  test('change selected sales breakdown wise successfully', () {
    //when
    salesPresenter.selectSalesBreakDownWiseAtIndex(SalesBreakDownWiseOptions.basedOnMenu.index);

    //then
    expect(salesPresenter.selectedBreakDownWise, SalesBreakDownWiseOptions.basedOnMenu);
    verify(() => view.onDidChangeSalesBreakDownWise());
  });

  // MARK: Test changing the sales break down filter's text color
  test('getSalesBreakdownTextColor() returns color successfully', () {
    //when
    salesPresenter.selectSalesBreakDownWiseAtIndex(SalesBreakDownWiseOptions.basedOnMenu.index);

    //then
    expect(salesPresenter.getSalesBreakdownTextColor(SalesBreakDownWiseOptions.basedOnMenu.index), Colors.white);
    verify(() => view.onDidChangeSalesBreakDownWise());
  });

  // MARK: Test changing the sales break down chip's background color
  test('getSalesBreakdownChipColor() returns color successfully', () {
    //when
    salesPresenter.selectSalesBreakDownWiseAtIndex(SalesBreakDownWiseOptions.basedOnMenu.index);

    //then
    expect(
        salesPresenter.getSalesBreakdownChipColor(SalesBreakDownWiseOptions.basedOnMenu.index), AppColors.defaultColor);
    verify(() => view.onDidChangeSalesBreakDownWise());
  });

  // MARK: Test Loading sales breakdown wise

  test('loading sales breakdowns when sales breakdowns provider is loading does nothing', () async {
    //given
    when(() => salesBreakDownProvider.isLoading).thenReturn(true);

    //when
    await salesPresenter.loadSalesBreakDown(singleTask: false);

    //then
    verify(() => salesBreakDownProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load sales breakdowns', () async {
    //given
    when(() => salesBreakDownProvider.isLoading).thenReturn(false);
    when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await salesPresenter.loadSalesBreakDown(singleTask: false);

    verifyInOrder([
      () => salesBreakDownProvider.isLoading,
      () => view.showLoader(),
      () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading sales breakdowns', () async {
    //given
    when(() => salesBreakDownProvider.isLoading).thenReturn(false);
    when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
        .thenAnswer((_) => Future.value(Mocks.salesBreakDownsItems));

    //when
    await salesPresenter.loadSalesBreakDown(singleTask: false);

    //then
    verifyInOrder([
      () => salesBreakDownProvider.isLoading,
      () => view.showLoader(),
      () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
      () => view.showSalesBreakDowns(),
    ]);

    expect(salesPresenter.getBreakdownAtIndex(0).value, '50');
    expect(salesPresenter.getBreakdownAtIndex(1).value, '20');
    expect(salesPresenter.getBreakdownAtIndex(2).value, '10');

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
    "getBreakdownAtIndex() returns the break down at a specific index",
    () async {
      //given
      when(() => salesBreakDownProvider.isLoading).thenReturn(false);
      when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
          .thenAnswer((_) => Future.value(Mocks.salesBreakDownsItems));

      //when
      await salesPresenter.loadSalesBreakDown(singleTask: false);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoader(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      _sortSalesDataItems();

      for (var i = 0; i < Mocks.salesBreakDownsItems.length; i++) {
        final currentItem = PerformanceValue(
          label: Mocks.salesBreakDownsItems[i].type,
          value: Mocks.salesBreakDownsItems[i].totalSales.withoutNullDecimals.commaSeparated,
          textColor: Mocks.colors[i],
        );

        expect(salesPresenter.getBreakdownAtIndex(i).label, currentItem.label);
        expect(salesPresenter.getBreakdownAtIndex(i).value, currentItem.value);
        expect(salesPresenter.getBreakdownAtIndex(i).textColor, currentItem.textColor);
      }

      _verifyNoMoreInteractionsOnAllMocks();
    },
  );
  test(
    "getSalesBreakdownValue() returns the break down value at a specific index",
    () async {
      //given
      when(() => salesBreakDownProvider.isLoading).thenReturn(false);
      when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
          .thenAnswer((_) => Future.value(Mocks.salesBreakDownsItems));

      //when
      await salesPresenter.loadSalesBreakDown(singleTask: false);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoader(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      _sortSalesDataItems();

      for (var i = 0; i < Mocks.salesBreakDownsItems.length; i++) {
        final currentItem = PerformanceValue(
          label: Mocks.salesBreakDownsItems[i].type,
          value: Mocks.salesBreakDownsItems[i].totalSales.withoutNullDecimals.commaSeparated,
          textColor: Mocks.colors[i],
        );

        expect(salesPresenter.getSalesBreakdownValue(i), currentItem.value);
      }

      _verifyNoMoreInteractionsOnAllMocks();
    },
  );

  test(
    "getSalesBreakdownLabel() returns the break down label at a specific index",
    () async {
      //given
      when(() => salesBreakDownProvider.isLoading).thenReturn(false);
      when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
          .thenAnswer((_) => Future.value(Mocks.salesBreakDownsItems));

      //when
      await salesPresenter.loadSalesBreakDown(singleTask: false);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoader(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      _sortSalesDataItems();

      for (var i = 0; i < Mocks.salesBreakDownsItems.length; i++) {
        final currentItem = PerformanceValue(
          label: Mocks.salesBreakDownsItems[i].type,
          value: Mocks.salesBreakDownsItems[i].totalSales.withoutNullDecimals.commaSeparated,
          textColor: Mocks.colors[i],
        );

        expect(salesPresenter.getSalesBreakdownLabel(i), currentItem.label);
      }

      _verifyNoMoreInteractionsOnAllMocks();
    },
  );

  test(
    "getNumberOfBreakdowns() returns 0 if it is null",
    () async {
      var salesBreakDowns = <SalesBreakDownItem>[];

      when(() => salesBreakDownProvider.isLoading).thenReturn(false);
      when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
          .thenAnswer((_) => Future.value(salesBreakDowns));

      //when
      await salesPresenter.loadSalesBreakDown(singleTask: false);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoader(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      expect(salesPresenter.getNumberOfBreakdowns(), 0);

      _verifyNoMoreInteractionsOnAllMocks();
    },
  );
  test(
    "breakdownsIsEmpty() returns true if the list is empty",
    () async {
      var salesBreakDowns = <SalesBreakDownItem>[];

      when(() => salesBreakDownProvider.isLoading).thenReturn(false);
      when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
          .thenAnswer((_) => Future.value(salesBreakDowns));

      //when
      await salesPresenter.loadSalesBreakDown(singleTask: false);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoader(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      expect(salesPresenter.breakdownsIsEmpty(), true);

      _verifyNoMoreInteractionsOnAllMocks();
    },
  );

  _testSalesData({required Map mockingData, required VoidCallback expectation}) async {
    //given
    when(() => salesDataProvider.isLoading).thenReturn(false);
    when(() => salesDataProvider.getSalesAmounts(dateFilter)).thenAnswer(
      (_) => Future.value(AggregatedSalesData.fromJson(mockingData)),
    );

    //when
    await salesPresenter.loadAggregatedSalesData();

    //then
    verifyInOrder([
      () => salesDataProvider.isLoading,
      () => view.showLoader(),
      () => salesDataProvider.getSalesAmounts(dateFilter),
      () => view.updateSalesData(),
    ]);

    expectation.call();

    _verifyNoMoreInteractionsOnAllMocks();
  }

  test(
    "getTotalSales() returns 0.00 for null value",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponseNull,
      expectation: () => expect(salesPresenter.getTotalSales(), "0.00"),
    ),
  );

  test(
    "getTotalSales() returns the correct value when provided",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponse,
      expectation: () => expect(salesPresenter.getTotalSales(), Mocks.salesDataRandomResponse["total_sales"]),
    ),
  );

  test(
    "getNetSale() returns 0.00 for null value",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponseNull,
      expectation: () => expect(salesPresenter.getNetSale(), "0.00"),
    ),
  );

  test(
    "getNetSale() returns the correct value when provided",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponse,
      expectation: () => expect(salesPresenter.getNetSale(), Mocks.salesDataRandomResponse["net_sales"]),
    ),
  );

  test(
    "getCostOfSales() returns 0.00 for null value",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponseNull,
      expectation: () => expect(salesPresenter.getCostOfSales(), "0.00"),
    ),
  );

  test(
    "getCostOfSales() returns the correct value when provided",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponse,
      expectation: () => expect(salesPresenter.getCostOfSales(), Mocks.salesDataRandomResponse["net_sales"]),
    ),
  );

  test(
    "getGrossProfit() returns 0.00 for null value",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponseNull,
      expectation: () => expect(salesPresenter.getGrossProfit(), "0.00" + "%"),
    ),
  );

  test(
    "getGrossProfit() returns the correct value when provided",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponse,
      expectation: () => expect(
          salesPresenter.getGrossProfit(), Mocks.salesDataRandomResponse["gross_profit_percentage"].toString() + "%"),
    ),
  );

  test(
    "getGrossProfitTextColor() returns red color if the gross of profit is negative ",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponseNegativeProfit,
      expectation: () => expect(salesPresenter.getGrossProfitTextColor(), Mocks.colors[2]),
    ),
  );

  test(
    "getGrossProfitTextColor() returns green color if the gross of profit is positive ",
    () async => _testSalesData(
      mockingData: Mocks.salesDataRandomResponse,
      expectation: () => expect(salesPresenter.getGrossProfitTextColor(), Mocks.colors[0]),
    ),
  );

  test("presenter notify view to show restaurant filters when restaurant filters got clicked", () {
    //when
    salesPresenter.onFiltersGotClicked();

    //then
    verify(
      () => view.showRestaurantDashboardFilter(),
    );

    _verifyNoMoreInteractionsOnAllMocks();
  });
}
