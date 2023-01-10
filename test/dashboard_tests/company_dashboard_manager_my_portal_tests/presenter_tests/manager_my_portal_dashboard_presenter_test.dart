import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/_wp_core/company_management/entities/wp_action.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/entities/manager_my_portal_data.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/services/manager_my_portal_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/presenters/manager_my_portal_dashboard_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/manager_my_portal_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_employee.dart';
import '../../../_mocks/mock_notification_center.dart';
import '../../../_mocks/mock_notification_observer.dart';

class MockManagerMyPortalView extends Mock implements ManagerMyPortalView {}

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockAggregatedApproval extends Mock implements AggregatedApproval {}

class MockManagerMyPortalData extends Mock implements ManagerMyPortalData {}

class MockManagerMyPortalDataProvider extends Mock implements ManagerMyPortalDataProvider {}

void main() {
  late MockManagerMyPortalView view;
  late MockManagerMyPortalDataProvider dataProvider;
  late MockCompanyProvider companyProvider;
  late MockNotificationCenter notificationCenter;
  late ManagerMyPortalDashboardPresenter presenter;

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
    view = MockManagerMyPortalView();
    dataProvider = MockManagerMyPortalDataProvider();
    companyProvider = MockCompanyProvider();
    notificationCenter = MockNotificationCenter();
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
    presenter = ManagerMyPortalDashboardPresenter.initWith(
      view,
      dataProvider,
      companyProvider,
      notificationCenter,
    );
    _clearInteractionsOnAllMocks();
  });

  test('starts listening to notifications on initialization', () async {
    //given
    presenter = ManagerMyPortalDashboardPresenter.initWith(
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
      () => notificationCenter.removeObserverFromAllChannels(key: "managerMyPortal"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load the data', () async {
    //given
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockManagerMyPortalData()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting filter', () async {
    //given
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockManagerMyPortalData()));

    //when
    await presenter.setFilter(month: 2, year: 2022);

    //then
    expect(presenter.selectedMonth, 2);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
      () => view.showLoader(),
      () => dataProvider.get(month: 2, year: 2022),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('setting month to 0 sets it to null in the provider', () async {
    //given
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockManagerMyPortalData()));

    //when
    await presenter.setFilter(month: 0, year: 2022);

    //then
    expect(presenter.selectedMonth, 0);
    expect(presenter.selectedYear, 2022);
    verifyInOrder([
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

    test('failure to sync data in the background', () async {
      //given
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(MockManagerMyPortalData()));
      await presenter.loadData();
      _clearInteractionsOnAllMocks();

      //when
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.syncDataInBackground();

      //then
      verifyInOrder([
        () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully syncing the data in the background', () async {
      //given
      var existingData = MockManagerMyPortalData();
      var existingApproval = MockAggregatedApproval();
      when(() => existingData.aggregatedApprovals).thenReturn([existingApproval]);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(existingData));
      await presenter.loadData();
      _clearInteractionsOnAllMocks();

      //when
      var newData = MockManagerMyPortalData();
      when(() => newData.aggregatedApprovals).thenReturn([]);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
          .thenAnswer((_) => Future.value(newData));
      await presenter.syncDataInBackground();

      //then
      expect(presenter.getTotalApprovalCount(), 0);
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

  test('getting department performance', () async {
    //given
    var data = MockManagerMyPortalData();
    when(() => data.departmentPerformance).thenReturn(87);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getDepartmentPerformance(), 87);
    expect(presenter.getDepartmentPerformanceDisplayValue(), "87%");
    expect(presenter.getDepartmentPerformanceLabel(), "YTD");

    await presenter.setFilter(month: 2, year: 2018);
    expect(presenter.getDepartmentPerformance(), 87);
    expect(presenter.getDepartmentPerformanceDisplayValue(), "87%");
    expect(presenter.getDepartmentPerformanceLabel(), "Feb 2018");
  });

  test('getting total approval count', () async {
    //given
    var approval1 = MockAggregatedApproval();
    var approval2 = MockAggregatedApproval();
    var approval3 = MockAggregatedApproval();
    when(() => approval1.approvalCount).thenReturn(3);
    when(() => approval2.approvalCount).thenReturn(4);
    when(() => approval3.approvalCount).thenReturn(23);
    var data = MockManagerMyPortalData();
    when(() => data.aggregatedApprovals).thenReturn([approval1, approval2, approval3]);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getTotalApprovalCount(), 30);
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
