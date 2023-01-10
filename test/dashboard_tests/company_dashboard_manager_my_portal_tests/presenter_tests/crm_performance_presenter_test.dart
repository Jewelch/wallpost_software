import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/entities/crm_dashboard_data.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/services/crm_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/models/manager_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/presenters/crm_performance_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';

class MockModulePerformanceView extends Mock implements ModulePerformanceView {}

class MockCRMDataProvider extends Mock implements CRMDashboardDataProvider {}

class MockCRMData extends Mock implements CRMDashboardData {}

void main() {
  var filters = ManagerDashboardFilters();
  var view = MockModulePerformanceView();
  var dataProvider = MockCRMDataProvider();
  var companyProvider = MockCompanyProvider();
  late CRMPerformancePresenter presenter;

  setUp(() {
    var company = MockCompany();
    when(() => company.currency).thenReturn("USD");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    presenter = CRMPerformancePresenter.initWith(view, filters, dataProvider, companyProvider);
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
        .thenAnswer((_) => Future.value(MockCRMData()));

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

  test("get actual revenue", () async {
    var data = MockCRMData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //negative
    when(() => data.isActualRevenuePositive()).thenReturn(false);
    when(() => data.actualRevenue).thenReturn("-120");
    expect(presenter.getActualRevenue().label, "Actual Revenue (USD)");
    expect(presenter.getActualRevenue().value, "-120");
    expect(presenter.getActualRevenue().textColor, AppColors.redOnDarkDefaultColorBg);

    //positive
    when(() => data.isActualRevenuePositive()).thenReturn(true);
    when(() => data.actualRevenue).thenReturn("1,33,000");
    expect(presenter.getActualRevenue().label, "Actual Revenue (USD)");
    expect(presenter.getActualRevenue().value, "1,33,000");
    expect(presenter.getActualRevenue().textColor, AppColors.greenOnDarkDefaultColorBg);
  });

  test("get target achieved", () async {
    var data = MockCRMData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //low
    when(() => data.targetAchievedPercent).thenReturn(10);
    expect(presenter.getTargetAchieved().label, "Target\nAchieved");
    expect(presenter.getTargetAchieved().value, "10%");
    expect(presenter.getTargetAchieved().textColor, AppColors.redOnDarkDefaultColorBg);

    //medium
    when(() => data.targetAchievedPercent).thenReturn(70);
    expect(presenter.getTargetAchieved().label, "Target\nAchieved");
    expect(presenter.getTargetAchieved().value, "70%");
    expect(presenter.getTargetAchieved().textColor, AppColors.yellow);

    //high
    when(() => data.targetAchievedPercent).thenReturn(90);
    expect(presenter.getTargetAchieved().label, "Target\nAchieved");
    expect(presenter.getTargetAchieved().value, "90%");
    expect(presenter.getTargetAchieved().textColor, AppColors.greenOnDarkDefaultColorBg);
  });

  test("get in pipeline", () async {
    var data = MockCRMData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.inPipeline).thenReturn("2,300");
    expect(presenter.getInPipeline().label, "In\nPipeline");
    expect(presenter.getInPipeline().value, "2,300");
    expect(presenter.getInPipeline().textColor, Colors.white);
  });

  test("get lead converted", () async {
    var data = MockCRMData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //low
    when(() => data.leadConvertedPercent).thenReturn(10);
    expect(presenter.getLeadConverted().label, "Lead\nConverted");
    expect(presenter.getLeadConverted().value, "10%");
    expect(presenter.getLeadConverted().textColor, AppColors.redOnDarkDefaultColorBg);

    //medium
    when(() => data.leadConvertedPercent).thenReturn(70);
    expect(presenter.getLeadConverted().label, "Lead\nConverted");
    expect(presenter.getLeadConverted().value, "70%");
    expect(presenter.getLeadConverted().textColor, AppColors.yellow);

    //high
    when(() => data.leadConvertedPercent).thenReturn(90);
    expect(presenter.getLeadConverted().label, "Lead\nConverted");
    expect(presenter.getLeadConverted().value, "90%");
    expect(presenter.getLeadConverted().textColor, AppColors.greenOnDarkDefaultColorBg);
  });
}
