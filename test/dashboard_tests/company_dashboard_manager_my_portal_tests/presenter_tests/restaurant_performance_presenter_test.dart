import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/entities/restaurant_dashboard_data.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/services/restaurant_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/models/manager_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/presenters/restaurant_performance_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

class MockModulePerformanceView extends Mock implements ModulePerformanceView {}

class MockRestaurantDataProvider extends Mock implements RestaurantDashboardDataProvider {}

class MockRestaurantData extends Mock implements RestaurantDashboardData {}

void main() {
  var filters = ManagerDashboardFilters();
  var view = MockModulePerformanceView();
  var dataProvider = MockRestaurantDataProvider();
  late RestaurantPerformancePresenter presenter;

  setUp(() {
    presenter = RestaurantPerformancePresenter.initWith(view, filters, dataProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
  }

  test('loading data when service is loading does nothing', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockRestaurantData()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('error message is reset before getting the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    presenter.loadData();

    expect(presenter.errorMessage, "");
  });

  test("get todays sales", () async {
    var data = MockRestaurantData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.todaysSale).thenReturn("1,234");
    expect(presenter.getTodaysSale().label, "Today's Sales");
    expect(presenter.getTodaysSale().value, "1,234");
    expect(presenter.getTodaysSale().textColor, Colors.white);
  });

  test("get ytd sales", () async {
    var data = MockRestaurantData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.ytdSale).thenReturn("13,234");
    expect(presenter.getYTDSale().label, "YTD Sales");
    expect(presenter.getYTDSale().value, "13,234");
    expect(presenter.getYTDSale().textColor, Colors.white);
  });
}
