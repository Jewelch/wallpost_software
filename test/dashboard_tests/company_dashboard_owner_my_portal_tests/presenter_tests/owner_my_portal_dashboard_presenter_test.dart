import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/_wp_core/company_management/entities/wp_action.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/entities/owner_my_portal_data.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/services/owner_my_portal_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/presenters/owner_my_portal_dashboard_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/owner_my_portal_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_employee.dart';
import '../../../_mocks/mock_notification_center.dart';
import '../../../_mocks/mock_notification_observer.dart';
import '../mocks.dart';

class MockOwnerMyPortalView extends Mock implements OwnerMyPortalView {}

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockAggregatedApproval extends Mock implements AggregatedApproval {}

class MockOwnerMyPortalData extends Mock implements OwnerMyPortalData {}

class MockOwnerMyPortalDataProvider extends Mock implements OwnerMyPortalDataProvider {}

void main() {
  late MockOwnerMyPortalView view;
  late MockOwnerMyPortalDataProvider dataProvider;
  late MockCompanyProvider companyProvider;
  late MockNotificationCenter notificationCenter;
  late OwnerMyPortalDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
    verifyNoMoreInteractions(companyProvider);
    verifyNoMoreInteractions(notificationCenter);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(dataProvider);
    clearInteractions(companyProvider);
    clearInteractions(notificationCenter);
  }

  setUpAll(() {
    registerFallbackValue(MockNotificationObserver());
  });

  setUp(() {
    view = MockOwnerMyPortalView();
    dataProvider = MockOwnerMyPortalDataProvider();
    companyProvider = MockCompanyProvider();
    notificationCenter = MockNotificationCenter();
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
    presenter = OwnerMyPortalDashboardPresenter.initWith(
      view,
      dataProvider,
      companyProvider,
      notificationCenter,
    );
    _clearInteractionsOnAllMocks();
  });

  test('starts listening to notifications on initialization', () async {
    //given
    presenter = OwnerMyPortalDashboardPresenter.initWith(
      view,
      dataProvider,
      companyProvider,
      notificationCenter,
    );

    //then
    verifyInOrder([
      () => notificationCenter.addExpenseApprovalRequiredObserver(any()),
      () => notificationCenter.addLeaveApprovalRequiredObserver(any()),
      () => notificationCenter.addAttendanceAdjustmentApprovalRequiredObserver(any()),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('stop listening to notifications', () async {
    //given
    presenter.stopListeningToNotifications();

    //then
    verifyInOrder([
      () => notificationCenter.removeObserverFromAllChannels(key: "ownerMyPortal"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('loading data when service is loading does nothing', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(true);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

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
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockOwnerMyPortalData()));

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

  test('setting filter', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockOwnerMyPortalData()));

    //when
    await presenter.setFilter(month: 2, year: 2022);

    //then
    expect(presenter.selectedMonth, 2);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: 2, year: 2022),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting month to 0 sets it to null in the provider', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockOwnerMyPortalData()));

    //when
    await presenter.setFilter(month: 0, year: 2022);

    //then
    expect(presenter.selectedMonth, 0);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: null, year: 2022),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  group('tests for syncing the data in the background', () {
    test('does nothing when there is no existing data', () async {
      //when
      await presenter.syncDataInBackground();

      //then
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('does nothing when retrieving dashboard data fails', () async {
      //given
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(MockOwnerMyPortalData()));
      await presenter.loadData();
      _clearInteractionsOnAllMocks();

      //when
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.error(InvalidResponseException()));
      presenter.syncDataInBackground();

      //then
      verifyInOrder([
        () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving updated data successfully with no changes', () async {
      //given
      var data = MockOwnerMyPortalData();
      var approval = MockAggregatedApproval();
      when(() => approval.approvalCount).thenReturn(10);
      when(() => data.aggregatedApprovals).thenReturn([approval]);
      when(() => data.absentees).thenReturn(10);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(data));
      await presenter.loadData();
      _clearInteractionsOnAllMocks();

      //when
      await presenter.syncDataInBackground();

      //then
      verifyInOrder([
        () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving updated data successfully with changes to approval count', () async {
      //given
      var existingData = MockOwnerMyPortalData();
      var existingApproval = MockAggregatedApproval();
      when(() => existingApproval.approvalCount).thenReturn(10);
      when(() => existingData.aggregatedApprovals).thenReturn([existingApproval]);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(existingData));
      await presenter.loadData();
      _clearInteractionsOnAllMocks();

      //when
      var newData = MockOwnerMyPortalData();
      var newApproval = MockAggregatedApproval();
      when(() => newApproval.approvalCount).thenReturn(6);
      when(() => newData.aggregatedApprovals).thenReturn([newApproval]);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(newData));
      await presenter.syncDataInBackground();

      //then
      verifyInOrder([
        () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
        () => view.onDidLoadData(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving updated data successfully with changes to number of absentees', () async {
      //given
      var existingData = MockOwnerMyPortalData();
      var existingApproval = MockAggregatedApproval();
      when(() => existingApproval.approvalCount).thenReturn(10);
      when(() => existingData.aggregatedApprovals).thenReturn([existingApproval]);
      when(() => existingData.absentees).thenReturn(20);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(existingData));
      await presenter.loadData();
      _clearInteractionsOnAllMocks();

      //when
      var newData = MockOwnerMyPortalData();
      var newApproval = MockAggregatedApproval();
      when(() => newApproval.approvalCount).thenReturn(10);
      when(() => newData.aggregatedApprovals).thenReturn([newApproval]);
      when(() => newData.absentees).thenReturn(10);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(newData));
      await presenter.syncDataInBackground();

      //then
      expect(presenter.getTotalApprovalCount(), 10);
      verifyInOrder([
        () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
        () => view.onDidLoadData(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  test('go to aggregated approvals screen', () {
    presenter.goToAggregatedApprovalsScreen();

    verifyInOrder([
      () => companyProvider.getSelectedCompanyForCurrentUser(),
      () => view.goToApprovalsListScreen("someCompanyId"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting financial summary', () async {
    //given
    var financialSummary = MockFinancialSummary();
    var data = MockOwnerMyPortalData();
    when(() => data.financialSummary).thenReturn(financialSummary);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getFinancialSummary(), financialSummary);
  });

  test('getting absentees data when there are no absentees', () async {
    //given
    var data = MockOwnerMyPortalData();
    when(() => data.absentees).thenReturn(0);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getAbsenteesData().value, 0);
    expect(presenter.getAbsenteesData().color, AppColors.green);
  });

  test('getting absentees data when there are absentees', () async {
    //given
    var data = MockOwnerMyPortalData();
    when(() => data.absentees).thenReturn(10);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getAbsenteesData().value, 10);
    expect(presenter.getAbsenteesData().color, AppColors.red);
  });

  test('getting total approval count', () async {
    //given
    var approval1 = MockAggregatedApproval();
    var approval2 = MockAggregatedApproval();
    var approval3 = MockAggregatedApproval();
    when(() => approval1.approvalCount).thenReturn(3);
    when(() => approval2.approvalCount).thenReturn(4);
    when(() => approval3.approvalCount).thenReturn(23);
    var data = MockOwnerMyPortalData();
    when(() => data.aggregatedApprovals).thenReturn([approval1, approval2, approval3]);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getTotalApprovalCount(), 30);
  });

  test('getting cutoff graph sections', () async {
    //given
    var data = OwnerMyPortalData.fromJson(Mocks.ownerMyPortalDataResponse, "USD");
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var cutoffSections = presenter.getCutoffPerformanceGraphSections();

    //then
    expect(cutoffSections[0].value, data.lowPerformanceCutoff());
    expect(cutoffSections[0].color, AppColors.red.withOpacity(0.3));

    expect(cutoffSections[1].value, data.mediumPerformanceCutoff() - data.lowPerformanceCutoff());
    expect(cutoffSections[1].color, AppColors.yellow.withOpacity(0.3));

    expect(cutoffSections[2].value, 100 - data.mediumPerformanceCutoff());
    expect(cutoffSections[2].color, AppColors.green.withOpacity(0.3));
  });

  test('getting graph values for low performance', () async {
    //given
    var map = Mocks.ownerMyPortalDataResponse;
    map["company_performance"] = 40;
    var data = OwnerMyPortalData.fromJson(map, "USD");
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var graphSections = presenter.getActualPerformanceGraphSections();

    //then
    expect(graphSections.length, 2);
    expect(graphSections[0].value, 40);
    expect(graphSections[0].color, AppColors.red);
    expect(graphSections[1].value, 60);
    expect(graphSections[1].color, Colors.transparent);

    expect(presenter.getCompanyPerformance().value, 40);
    expect(presenter.getCompanyPerformance().color, AppColors.red);
  });

  test('getting graph values for medium performance', () async {
    //given
    var map = Mocks.ownerMyPortalDataResponse;
    map["company_performance"] = 70;
    var data = OwnerMyPortalData.fromJson(map, "USD");
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var graphSections = presenter.getActualPerformanceGraphSections();

    //then
    expect(graphSections.length, 3);
    expect(graphSections[0].value, data.lowPerformanceCutoff());
    expect(graphSections[0].color, AppColors.red);
    expect(graphSections[1].value, 5);
    expect(graphSections[1].color, AppColors.yellow);
    expect(graphSections[2].value, 30);
    expect(graphSections[2].color, Colors.transparent);

    expect(presenter.getCompanyPerformance().value, 70);
    expect(presenter.getCompanyPerformance().color, AppColors.yellow);
  });

  test('getting graph values for high performance', () async {
    //given
    var map = Mocks.ownerMyPortalDataResponse;
    map["company_performance"] = 95;
    var data = OwnerMyPortalData.fromJson(map, "USD");
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var graphSections = presenter.getActualPerformanceGraphSections();

    //then
    expect(graphSections.length, 4);
    expect(graphSections[0].value, data.lowPerformanceCutoff());
    expect(graphSections[0].color, AppColors.red);
    expect(graphSections[1].value, data.mediumPerformanceCutoff() - data.lowPerformanceCutoff());
    expect(graphSections[1].color, AppColors.yellow);
    expect(graphSections[2].value, 16);
    expect(graphSections[2].color, AppColors.green);
    expect(graphSections[3].value, 5);
    expect(graphSections[3].color, Colors.transparent);

    expect(presenter.getCompanyPerformance().value, 95);
    expect(presenter.getCompanyPerformance().color, AppColors.green);
  });

  group('tests for getting and selection request items', () {
    test('get request items', () {
      //given
      var employee = MockEmployee();
      when(() => employee.allowedActions).thenReturn([
        WPAction.PayrollAdjustment,
        WPAction.Leave,
        WPAction.Expense,
      ]);
      var company = MockCompany();
      when(() => company.employee).thenReturn(employee);
      when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

      //when
      var requestItems = presenter.getRequestItems();

      //then
      expect(requestItems, [
        WPAction.PayrollAdjustment.toReadableString(),
        WPAction.Leave.toReadableString(),
        WPAction.Expense.toReadableString(),
      ]);
    });

    test('selecting leave request item', () {
      //given
      var employee = MockEmployee();
      when(() => employee.allowedActions).thenReturn([
        WPAction.PayrollAdjustment,
        WPAction.Leave,
        WPAction.Expense,
      ]);
      var company = MockCompany();
      when(() => company.employee).thenReturn(employee);
      when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

      //when
      presenter.selectRequestItemAtIndex(1);

      //then
      verifyInOrder([
        () => companyProvider.getSelectedCompanyForCurrentUser(),
        () => view.showLeaveActions(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('selecting expense request item', () {
      //given
      var employee = MockEmployee();
      when(() => employee.allowedActions).thenReturn([
        WPAction.PayrollAdjustment,
        WPAction.Leave,
        WPAction.Expense,
      ]);
      var company = MockCompany();
      when(() => company.employee).thenReturn(employee);
      when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

      //when
      presenter.selectRequestItemAtIndex(2);

      //then
      verifyInOrder([
        () => companyProvider.getSelectedCompanyForCurrentUser(),
        () => view.showExpenseActions(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('selecting payroll adjustment item', () {
      //given
      var employee = MockEmployee();
      when(() => employee.allowedActions).thenReturn([
        WPAction.PayrollAdjustment,
        WPAction.Leave,
        WPAction.Expense,
      ]);
      var company = MockCompany();
      when(() => company.employee).thenReturn(employee);
      when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

      //when
      presenter.selectRequestItemAtIndex(0);

      //then
      verifyInOrder([
        () => companyProvider.getSelectedCompanyForCurrentUser(),
        () => view.showPayrollAdjustmentActions(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });
}
