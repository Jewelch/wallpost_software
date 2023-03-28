import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/crm/dashboard/entities/crm_dashboard_data.dart';
import 'package:wallpost/crm/dashboard/entities/service_performance.dart';
import 'package:wallpost/crm/dashboard/entities/staff_performance.dart';
import 'package:wallpost/crm/dashboard/services/crm_dashboard_data_provider.dart';
import 'package:wallpost/crm/dashboard/ui/models/crm_dashboard_filters.dart';
import 'package:wallpost/crm/dashboard/ui/presenters/crm_dashboard_presenter.dart';
import 'package:wallpost/crm/dashboard/ui/view_contracts/crm_dashboard_view.dart';
import 'package:wallpost/crm/dashboard/ui/views/widgets/crm_dashboard_no_performance_tile.dart';
import 'package:wallpost/crm/dashboard/ui/views/widgets/crm_dashboard_service_performance_tile.dart';
import 'package:wallpost/crm/dashboard/ui/views/widgets/crm_dashboard_staff_performance_tile.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';

class MockCrmDashboardView extends Mock implements CrmDashboardView {}

class MockCrmDashboardDataProvider extends Mock implements CrmDashboardDataProvider {}

class MockCrmDashboardData extends Mock implements CrmDashboardData {}

class MockStaffPerformance extends Mock implements StaffPerformance {}

class MockServicePerformance extends Mock implements ServicePerformance {}

void main() {
  var view = MockCrmDashboardView();
  var dataProvider = MockCrmDashboardDataProvider();
  var companyProvider = MockCompanyProvider();
  late CrmDashboardPresenter presenter;

  setUp(() {
    reset(view);
    reset(dataProvider);
    reset(companyProvider);
    presenter = CrmDashboardPresenter.initWith(view, dataProvider, companyProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
  }

  //MARK: Tests for loading data

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
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidFailToLoadData("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockCrmDashboardData()));

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

  //MARK: Tests for applying YTD filters

  test('default filters', () async {
    expect(presenter.getSelectedMonthName(), "YTD");
    expect(presenter.getSelectedYear(), AppYears().getCurrentYear());
  });

  test('initiating filter selection', () async {
    presenter.initiateYTDFilterSelection();

    verifyInOrder([
      () => view.showYTDFilters(0, AppYears().getCurrentYear()),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting YTD filter', () async {
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockCrmDashboardData()));

    await presenter.setYTDFilter(month: 5, year: 2020);

    expect(presenter.getSelectedMonthName(), "May");
    expect(presenter.getSelectedYear(), 2020);
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: 5, year: 2020),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for applying performance type filters

  test('getting performance filter titles', () {
    expect(presenter.getPerformanceTypeFilters(), PerformanceType.values.map((e) => e.toReadableString()).toList());

    expect(presenter.getPerformanceFilterNameAtIndex(0), PerformanceType.values[0].toReadableString());
    expect(presenter.getPerformanceFilterNameAtIndex(1), PerformanceType.values[1].toReadableString());
  });

  test('selecting performance type', () {
    //default
    expect(presenter.getPerformanceFilterBackgroundColor(0), AppColors.defaultColor);
    expect(presenter.getPerformanceFilterTextColor(0), Colors.white);
    expect(presenter.getPerformanceFilterBackgroundColor(1), Colors.white);
    expect(presenter.getPerformanceFilterTextColor(1), AppColors.defaultColor);

    presenter.selectPerformanceTypeAtIndex(1);
    expect(presenter.getPerformanceFilterBackgroundColor(0), Colors.white);
    expect(presenter.getPerformanceFilterTextColor(0), AppColors.defaultColor);
    expect(presenter.getPerformanceFilterBackgroundColor(1), AppColors.defaultColor);
    expect(presenter.getPerformanceFilterTextColor(1), Colors.white);
  });

  //MARK: Tests for getters

  test('getters', () async {
    var data = MockCrmDashboardData();
    when(() => data.salesThisYear).thenReturn("10");
    when(() => data.targetAchievedPercentage).thenReturn("20");
    when(() => data.inPipeline).thenReturn("30");
    when(() => data.leadConversionPercentage).thenReturn("70");
    when(() => data.salesGrowthPercentage).thenReturn("80");

    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    expect(presenter.getSalesThisYear().label, "Sales This Year");
    expect(presenter.getSalesThisYear().value, "10");
    expect(presenter.getSalesThisYear().textColor, AppColors.brightGreen);
    expect(presenter.getSalesThisYear().backgroundColor, AppColors.lightGreen);

    expect(presenter.getTargetAchieved().label, "Target Achieved");
    expect(presenter.getTargetAchieved().value, "20%");
    expect(presenter.getTargetAchieved().textColor, AppColors.red);
    expect(presenter.getTargetAchieved().backgroundColor, AppColors.lightRed);

    expect(presenter.getInPipeline().label, "In Pipeline");
    expect(presenter.getInPipeline().value, "30");
    expect(presenter.getInPipeline().textColor, AppColors.textColorBlack);
    expect(presenter.getInPipeline().backgroundColor, AppColors.screenBackgroundColor2);

    expect(presenter.getLeadConversion().label, "Lead Conversion");
    expect(presenter.getLeadConversion().value, "70%");
    expect(presenter.getLeadConversion().textColor, AppColors.yellow);
    expect(presenter.getLeadConversion().backgroundColor, AppColors.lightYellow);

    expect(presenter.getSalesGrowth().label, "Sales Growth");
    expect(presenter.getSalesGrowth().value, "80%");
    expect(presenter.getSalesGrowth().textColor, AppColors.brightGreen);
    expect(presenter.getSalesGrowth().backgroundColor, AppColors.lightGreen);
  });

  test('getting number of list items and list item tiles', () async {
    var data = MockCrmDashboardData();

    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //no data
    when(() => data.staffPerformances).thenReturn([]);
    when(() => data.servicePerformances).thenReturn([]);

    presenter.selectPerformanceTypeAtIndex(0);
    expect(presenter.getNumberOfListItems(), 1);
    expect(presenter.getTileForItemAtIndex(0) is CrmDashboardNoPerformanceTile, true);

    presenter.selectPerformanceTypeAtIndex(1);
    expect(presenter.getNumberOfListItems(), 1);
    expect(presenter.getTileForItemAtIndex(0) is CrmDashboardNoPerformanceTile, true);

    //with data
    when(() => data.staffPerformances)
        .thenReturn([MockStaffPerformance(), MockStaffPerformance(), MockStaffPerformance()]);
    when(() => data.servicePerformances).thenReturn([MockServicePerformance(), MockServicePerformance()]);

    presenter.selectPerformanceTypeAtIndex(0);
    expect(presenter.getNumberOfListItems(), 3);
    expect(presenter.getTileForItemAtIndex(0) is CrmDashboardStaffPerformanceTile, true);
    expect(presenter.getTileForItemAtIndex(1) is CrmDashboardStaffPerformanceTile, true);
    expect(presenter.getTileForItemAtIndex(2) is CrmDashboardStaffPerformanceTile, true);

    presenter.selectPerformanceTypeAtIndex(1);
    expect(presenter.getNumberOfListItems(), 2);
    expect(presenter.getTileForItemAtIndex(0) is CrmDashboardServicePerformanceTile, true);
    expect(presenter.getTileForItemAtIndex(1) is CrmDashboardServicePerformanceTile, true);
  });

  test('getting number of list items and list item tiles', () async {
    var data = MockCrmDashboardData();
    var staffPerformance = MockStaffPerformance();
    var servicePerformance = MockServicePerformance();
    when(() => data.staffPerformances).thenReturn([staffPerformance]);
    when(() => data.servicePerformances).thenReturn([servicePerformance]);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => staffPerformance.profileImageUrl).thenReturn("someUrl.com");
    expect(presenter.getStaffProfileImageUrl(staffPerformance), "someUrl.com");

    when(() => staffPerformance.name).thenReturn("Some Staff");
    expect(presenter.getStaffName(staffPerformance), "Some Staff");

    when(() => staffPerformance.target).thenReturn("1122");
    expect(presenter.getStaffTargetAmount(staffPerformance), "1122");

    when(() => staffPerformance.actual).thenReturn("3344");
    expect(presenter.getStaffActualAmount(staffPerformance), "3344");

    when(() => staffPerformance.performancePercentage).thenReturn("30");
    expect(presenter.getStaffPerformancePercentage(staffPerformance).label, "");
    expect(presenter.getStaffPerformancePercentage(staffPerformance).value, "30%");
    expect(presenter.getStaffPerformancePercentage(staffPerformance).textColor, AppColors.red);
    expect(presenter.getStaffPerformancePercentage(staffPerformance).backgroundColor, Colors.white);

    when(() => servicePerformance.name).thenReturn("Some Service");
    expect(presenter.getServiceName(servicePerformance), "Some Service");

    when(() => servicePerformance.target).thenReturn("5566");
    expect(presenter.getServiceTargetAmount(servicePerformance), "5566");

    when(() => servicePerformance.actual).thenReturn("7788");
    expect(presenter.getServiceActualAmount(servicePerformance), "7788");

    when(() => servicePerformance.performancePercentage).thenReturn("80");
    expect(presenter.getServicePerformancePercentage(servicePerformance).label, "");
    expect(presenter.getServicePerformancePercentage(servicePerformance).value, "80%");
    expect(presenter.getServicePerformancePercentage(servicePerformance).textColor, AppColors.green);
    expect(presenter.getServicePerformancePercentage(servicePerformance).backgroundColor, Colors.white);
  });

  test('get company name and currency', () {
    var company = MockCompany();
    when(() => company.name).thenReturn("Some Name");
    when(() => company.currency).thenReturn("USD");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    expect(presenter.getCompanyName(), "Some Name");
    expect(presenter.getCurrency(), "USD");
  });
}
