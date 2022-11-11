import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/entities/retail_dashboard_data.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/services/retail_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/models/owner_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/presenters/retail_performance_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';

class MockModulePerformanceView extends Mock implements ModulePerformanceView {}

class MockRetailDataProvider extends Mock implements RetailDashboardDataProvider {}

class MockRetailData extends Mock implements RetailDashboardData {}

void main() {
  var filters = OwnerDashboardFilters();
  var view = MockModulePerformanceView();
  var dataProvider = MockRetailDataProvider();
  late RetailPerformancePresenter presenter;

  setUp(() {
    presenter = RetailPerformancePresenter.initWith(view, filters, dataProvider);
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
        .thenAnswer((_) => Future.value(MockRetailData()));

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
    var data = MockRetailData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.todaysSale).thenReturn("1,234");
    expect(presenter.getTodaysSale().label, "Today's Sales");
    expect(presenter.getTodaysSale().value, "1,234");
    expect(presenter.getTodaysSale().textColor, AppColors.textColorBlack);
  });

  test("get ytd sales", () async {
    var data = MockRetailData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.ytdSale).thenReturn("13,234");
    expect(presenter.getYTDSale().label, "YTD Sales");
    expect(presenter.getYTDSale().value, "13,234");
    expect(presenter.getYTDSale().textColor, AppColors.textColorBlack);
  });
}
