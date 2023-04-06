import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/models/performance_value.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/entities/aggregated_sales_data.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/entities/sales_break_down_item.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/services/aggregated_sales_data_provider.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/services/sales_breakdowns_provider.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/ui/presenters/dashboard_presenter.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/ui/view_contracts/dashboard_view.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/ui/views/screens/dashboard_screen.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../../mocks.dart';

class MockSalesDataProvider extends Mock implements AggregatedSalesDataProvider {}

class MockSalesDataView extends Mock implements DashboardView {}

class MockSalesBreakDownProvider extends Mock implements SalesBreakDownsProvider {}

class MockAggregatedSalesData extends Mock implements AggregatedSalesData {}

class MockSalesBreakDowns extends Mock implements SalesBreakDownItem {}

void main() {
  var salesDataProvider = MockSalesDataProvider();
  var salesBreakDownProvider = MockSalesBreakDownProvider();
  var view = MockSalesDataView();
  var dateFilter = DateRange();
  late DashboardPresenter presenter;

  void _initializePresenter() {
    presenter = DashboardPresenter.initWith(
      DashboardContext.restaurant,
      view,
      salesDataProvider,
      salesBreakDownProvider,
      dateFilter,
      MockCompanyProvider(),
    );
  }

  _initializePresenter();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(salesDataProvider);
    verifyNoMoreInteractions(salesBreakDownProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(salesDataProvider);
    clearInteractions(salesBreakDownProvider);
  }

  setUpAll(() {
    registerFallbackValue(SalesBreakDownWiseOptions.basedOnOrder);
  });

  _sortSalesDataItems() => Mocks.salesBreakDownsItems
    ..sort(
      (a, b) => b.totalSales.compareTo(a.totalSales),
    );

  // MARK: Test Loading Aggregated Sales Data

  test("presenter return 0.0 for Aggregated sales data when Aggregated sales data is uninitialized yet", () {
    _initializePresenter();

    expect(presenter.getTotalSales(), "0.00");
    expect(presenter.getNetSale(), "0.00");
    expect(presenter.getCostOfSales(), "0.00");
    expect(presenter.getGrossProfit(), "0.00" + "%");
    _clearInteractionsOnAllMocks();
  });

  test("presenter return Aggregated sales data when Aggregated sales data is initialized", () async {
    //given
    var aggregatedSalesData = AggregatedSalesData.fromJson(Mocks.salesDataRandomResponse);
    when(() => salesDataProvider.isLoading).thenReturn(false);
    when(() => salesDataProvider.getSalesAmounts(dateFilter)).thenAnswer(
      (_) => Future.value(aggregatedSalesData),
    );

    //when
    await presenter.loadAggregatedSalesData();

    expect(presenter.getTotalSales(), aggregatedSalesData.totalSales);
    expect(presenter.getNetSale(), aggregatedSalesData.netSales);
    expect(presenter.getCostOfSales(), aggregatedSalesData.costOfSales);
    expect(presenter.getGrossProfit(), aggregatedSalesData.grossOfProfit + "%");
    _clearInteractionsOnAllMocks();
  });

  test("presenter return green color if the gross of profit is positive", () async {
    //given
    var map = Mocks.salesDataRandomResponse;
    map["gross_profit_percentage"] = 80;
    var aggregatedSalesData = AggregatedSalesData.fromJson(map);
    when(() => salesDataProvider.isLoading).thenReturn(false);
    when(() => salesDataProvider.getSalesAmounts(dateFilter)).thenAnswer(
      (_) => Future.value(aggregatedSalesData),
    );

    //when
    await presenter.loadAggregatedSalesData();

    expect(presenter.getGrossProfitTextColor(), AppColors.green);
    _clearInteractionsOnAllMocks();
  });

  test("presenter return red color if the gross of profit is negative", () async {
    //given
    var map = Mocks.salesDataRandomResponse;
    map["gross_profit_percentage"] = -80;
    var aggregatedSalesData = AggregatedSalesData.fromJson(map);
    when(() => salesDataProvider.isLoading).thenReturn(false);
    when(() => salesDataProvider.getSalesAmounts(dateFilter)).thenAnswer(
      (_) => Future.value(aggregatedSalesData),
    );

    //when
    await presenter.loadAggregatedSalesData();

    expect(presenter.getGrossProfitTextColor(), AppColors.red);
    _clearInteractionsOnAllMocks();
  });

  test('loading sales data when sales data provider is loading does nothing', () async {
    //given
    when(() => salesDataProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadAggregatedSalesData();

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
    await presenter.loadAggregatedSalesData();

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
    await presenter.loadAggregatedSalesData();

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
    presenter.selectSalesBreakDownFilter(SalesBreakDownWiseOptions.basedOnMenu);

    //then
    expect(presenter.selectedBreakDownWise, SalesBreakDownWiseOptions.basedOnMenu);
    verify(() => view.onDidChangeSalesBreakDownWise());
  });

  // MARK: Test changing the sales break down filter's text color
  test('getSalesBreakdownTextColor() returns color successfully', () {
    //when
    presenter.selectSalesBreakDownFilter(SalesBreakDownWiseOptions.basedOnMenu);

    //then
    expect(presenter.getSalesBreakdownFilterTextColor(SalesBreakDownWiseOptions.basedOnMenu), Colors.white);
    verify(() => view.onDidChangeSalesBreakDownWise());
  });

  // MARK: Test changing the sales break down chip's background color
  test('getSalesBreakdownChipColor() returns color successfully', () {
    //when
    presenter.selectSalesBreakDownFilter(SalesBreakDownWiseOptions.basedOnMenu);

    //then
    expect(presenter.getSalesBreakdownFilterBackgroundColor(SalesBreakDownWiseOptions.basedOnMenu),
        AppColors.defaultColor);
    verify(() => view.onDidChangeSalesBreakDownWise());
  });

  // MARK: Test Loading sales breakdown wise

  test('loading sales breakdowns when sales breakdowns provider is loading does nothing', () async {
    //given
    when(() => salesBreakDownProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadSalesBreakDown(singleTask: false);

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
    await presenter.loadSalesBreakDown(singleTask: false);

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
    await presenter.loadSalesBreakDown(singleTask: false);

    //then
    verifyInOrder([
      () => salesBreakDownProvider.isLoading,
      () => view.showLoader(),
      () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
      () => view.showSalesBreakDowns(),
    ]);

    _sortSalesDataItems();

    expect(presenter.getBreakdownAtIndex(0).value, Mocks.salesBreakDownsItems.first.totalSalesDisplayValue);
    expect(presenter.getBreakdownAtIndex(1).value, Mocks.salesBreakDownsItems[1].totalSalesDisplayValue);
    expect(presenter.getBreakdownAtIndex(2).value, Mocks.salesBreakDownsItems.last.totalSalesDisplayValue);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
    "getBreakdownAtIndex() returns the break down at a specific index",
    () async {
      //given
      when(() => salesBreakDownProvider.isLoading).thenReturn(false);
      when(() => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter))
          .thenAnswer((_) => Future.value(List.from(Mocks.salesBreakDownsItems)));

      //when
      await presenter.loadSalesBreakDown(singleTask: true);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoadingForSalesBreakDowns(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      _sortSalesDataItems();

      for (var i = 0; i < Mocks.salesBreakDownsItems.length; i++) {
        final currentItem = PerformanceValue(
          label: Mocks.salesBreakDownsItems[i].type,
          value: Mocks.salesBreakDownsItems[i].totalSalesDisplayValue,
          textColor: AppColors.textColorBlack,
        );

        expect(presenter.getBreakdownAtIndex(i).label, currentItem.label);
        expect(presenter.getBreakdownAtIndex(i).value, currentItem.value);
        expect(presenter.getBreakdownAtIndex(i).textColor, currentItem.textColor);
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
          .thenAnswer((_) => Future.value(List.from(Mocks.salesBreakDownsItems)));

      //when
      await presenter.loadSalesBreakDown(singleTask: true);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoadingForSalesBreakDowns(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showSalesBreakDowns(),
      ]);

      _sortSalesDataItems();

      for (var i = 0; i < Mocks.salesBreakDownsItems.length; i++) {
        final currentItem = PerformanceValue(
          label: Mocks.salesBreakDownsItems[i].type,
          value: Mocks.salesBreakDownsItems[i].totalSalesDisplayValue,
          textColor: AppColors.textColorBlack,
        );

        expect(presenter.getSalesBreakdownValue(i), currentItem.value);
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
      await presenter.loadSalesBreakDown(singleTask: true);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoadingForSalesBreakDowns(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showNoSalesBreakdownMessage(),
      ]);

      expect(presenter.getNumberOfBreakdowns(), 0);

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
      await presenter.loadSalesBreakDown(singleTask: true);

      //then
      verifyInOrder([
        () => salesBreakDownProvider.isLoading,
        () => view.showLoadingForSalesBreakDowns(),
        () => salesBreakDownProvider.getSalesBreakDowns(any(), dateFilter),
        () => view.showNoSalesBreakdownMessage(),
      ]);

      expect(presenter.breakdownsListIsEmpty(), true);

      _verifyNoMoreInteractionsOnAllMocks();
    },
  );

  test("presenter notify view to show restaurant filters when restaurant filters got clicked", () {
    //when
    presenter.onFiltersGotClicked();

    //then
    verify(view.showRestaurantDashboardFilter);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
