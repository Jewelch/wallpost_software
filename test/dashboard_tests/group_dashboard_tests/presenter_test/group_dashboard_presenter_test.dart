import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/_wp_core/company_management/services/company_selector.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/attendance_details_provider.dart';
import 'package:wallpost/dashboard/group_dashboard/entities/company_group.dart';
import 'package:wallpost/dashboard/group_dashboard/entities/group_dashboard_data.dart';
import 'package:wallpost/dashboard/group_dashboard/services/group_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/group_dashboard/ui/presenters/group_dashboard_presenter.dart';
import 'package:wallpost/dashboard/group_dashboard/ui/view_contracts/group_dashboard_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_current_user_provider.dart';
import '../../../_mocks/mock_notification_center.dart';
import '../../../_mocks/mock_notification_observer.dart';
import '../../../_mocks/mock_user.dart';

class MockGroupDashboardView extends Mock implements GroupDashboardView {}

class MockGroupDashboardDataProvider extends Mock implements GroupDashboardDataProvider {}

class MockGroupDashboardData extends Mock implements GroupDashboardData {}

class MockCompanySelector extends Mock implements CompanySelector {}

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockCompanyGroup extends Mock implements CompanyGroup {}

class MockAttendanceDetailsProvider extends Mock implements AttendanceDetailsProvider {}

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

void main() {
  late MockCompany company1;
  late MockCompany company2;
  late MockCompanyGroup companyGroup1;
  late MockCompanyGroup companyGroup2;
  late MockFinancialSummary financialSummary;
  late MockGroupDashboardData groupDashboardData;

  var view = MockGroupDashboardView();
  var mockCurrentUserProvider = MockCurrentUserProvider();
  var mockDashboardDataProvider = MockGroupDashboardDataProvider();
  var mockCompanySelector = MockCompanySelector();
  var mockAttendanceProvider = MockAttendanceDetailsProvider();
  var notificationCenter = MockNotificationCenter();
  late GroupDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockCurrentUserProvider);
    verifyNoMoreInteractions(mockDashboardDataProvider);
    verifyNoMoreInteractions(mockAttendanceProvider);
    verifyNoMoreInteractions(notificationCenter);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(mockCurrentUserProvider);
    clearInteractions(mockDashboardDataProvider);
    clearInteractions(mockAttendanceProvider);
    clearInteractions(notificationCenter);
  }

  setUp(() {
    company1 = MockCompany();
    company2 = MockCompany();
    companyGroup1 = MockCompanyGroup();
    companyGroup2 = MockCompanyGroup();
    financialSummary = MockFinancialSummary();
    groupDashboardData = MockGroupDashboardData();

    when(() => company1.name).thenReturn("test1");
    when(() => company1.id).thenReturn("1");
    when(() => company1.approvalCount).thenReturn(10);
    when(() => company2.name).thenReturn("test2");
    when(() => company2.id).thenReturn("2");
    when(() => company2.approvalCount).thenReturn(8);
    when(() => companyGroup1.companyIds).thenReturn(["1"]);

    presenter = GroupDashboardPresenter.initWith(
      view,
      mockCurrentUserProvider,
      mockDashboardDataProvider,
      mockCompanySelector,
      mockAttendanceProvider,
      notificationCenter,
    );
    _clearInteractionsOnAllMocks();
  });

  setUpAll(() {
    registerFallbackValue(MockNotificationObserver());
  });

  test('starts listening to notifications on initialization', () async {
    //given
    presenter = GroupDashboardPresenter.initWith(
      view,
      mockCurrentUserProvider,
      mockDashboardDataProvider,
      mockCompanySelector,
      mockAttendanceProvider,
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
      () => notificationCenter.removeObserverFromAllChannels(key: "groupDashboard"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  group('tests for loading the data', () {
    test('does nothing if the provider is loading', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(true);

      //when
      await presenter.loadDashboardData();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving companies failed', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.loadDashboardData();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.isLoading,
        () => view.showLoader(),
        () => mockDashboardDataProvider.get(),
        () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving companies successfully with no companies', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);

      //when
      await presenter.loadDashboardData();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.isLoading,
        () => view.showLoader(),
        () => mockDashboardDataProvider.get(),
        () => view.showErrorMessage("There are no companies.\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving companies successfully ', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);

      //when
      await presenter.loadDashboardData();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.isLoading,
        () => view.showLoader(),
        () => mockDashboardDataProvider.get(),
        () => view.onDidLoadData(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('refreshing the list of companies', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      await presenter.refresh();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.isLoading,
        () => view.showLoader(),
        () => mockDashboardDataProvider.get(),
        () => view.onDidLoadData(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
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
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));
      presenter.syncDataInBackground();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.get(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('failure to sync data in background', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.syncDataInBackground();

      //then
      verifyInOrder([
        () => mockDashboardDataProvider.get(),
        () => view
            .showErrorMessageBanner("Failed to sync updated data.\n${InvalidResponseException().userReadableMessage}"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully syncing the data in background', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      var newData = MockGroupDashboardData();
      var newCompany1 = MockCompany();
      var newCompany2 = MockCompany();
      when(() => newCompany1.id).thenReturn("1");
      when(() => newCompany2.id).thenReturn("2");
      when(() => newCompany1.name).thenReturn("comp1");
      when(() => newCompany2.name).thenReturn("comp2");
      when(() => newCompany1.approvalCount).thenReturn(2);
      when(() => newCompany2.approvalCount).thenReturn(3);
      when(() => newData.companies).thenReturn([newCompany1, newCompany2]);
      when(() => newData.financialSummary).thenReturn(null);
      when(() => newData.groups).thenReturn([]);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(newData));
      await presenter.syncDataInBackground();

      //then
      expect(presenter.getApprovalCount(), 5);
      expect(presenter.getItemAtIndex(0), newCompany1);
      expect(presenter.getItemAtIndex(1), newCompany2);
      expect(presenter.getCompanyGroups(), []);
      verifyInOrder([
        () => mockDashboardDataProvider.get(),
        () => view.onDidLoadData(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('removed selected group if that group is removed from the updated data', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([companyGroup1]);
      await presenter.loadDashboardData();
      presenter.selectGroupAtIndex(0);
      _clearInteractionsOnAllMocks();

      //when
      var newData = MockGroupDashboardData();
      when(() => newData.companies).thenReturn([MockCompany()]);
      when(() => newData.financialSummary).thenReturn(null);
      when(() => newData.groups).thenReturn([]);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(newData));
      await presenter.syncDataInBackground();

      //then
      expect(presenter.getSelectedCompanyGroup(), null);
      verifyInOrder([
        () => mockDashboardDataProvider.get(),
        () => view.onDidLoadData(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for loading attendance', () {
    test('failure to load attendance details does nothing', () async {
      //given
      when(() => mockAttendanceProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceProvider.getDetails()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceProvider.getDetails(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('loading attendance details when attendance is not applicable does nothing', () async {
      //given
      var attendanceDetails = MockAttendanceDetails();
      when(() => attendanceDetails.isAttendanceApplicable).thenReturn(false);
      when(() => mockAttendanceProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceProvider.getDetails()).thenAnswer((_) => Future.value(attendanceDetails));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceProvider.getDetails(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('loading attendance details when attendance is applicable shows the attendance widget', () async {
      //given
      var attendanceDetails = MockAttendanceDetails();
      when(() => attendanceDetails.isAttendanceApplicable).thenReturn(true);
      when(() => mockAttendanceProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceProvider.getDetails()).thenAnswer((_) => Future.value(attendanceDetails));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceProvider.getDetails(),
        () => view.showAttendanceWidget(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('getting list details', () {
    test('number of items when there are no companies', () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([]);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);

      //when
      await presenter.loadDashboardData();

      //then
      expect(presenter.getNumberOfRows(), 0);
    });

    test('number of items when there are companies and user cannot access financial data', () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(false);
      when(() => groupDashboardData.groups).thenReturn([]);

      //when
      await presenter.loadDashboardData();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
    });

    test(
        'number of items when there are companies and user has access financial data but overall financial data is null',
        () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(true);
      when(() => groupDashboardData.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([]);

      //when
      await presenter.loadDashboardData();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
    });

    test(
        'number of items when there are companies and user has access to financial data and overall financial data is not null',
        () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(true);
      when(() => groupDashboardData.financialSummary).thenReturn(financialSummary);
      when(() => groupDashboardData.groups).thenReturn([]);

      //when
      await presenter.loadDashboardData();

      //then
      expect(presenter.getNumberOfRows(), 3);
      expect(presenter.getItemAtIndex(0), financialSummary);
      expect(presenter.getItemAtIndex(1), company1);
      expect(presenter.getItemAtIndex(2), company2);
    });

    test('number of items when group filter is selected and group financial data is null', () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(true);
      when(() => companyGroup1.financialSummary).thenReturn(null);
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);

      //when
      await presenter.loadDashboardData();
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 1);
      expect(presenter.getItemAtIndex(0), company1);
    });

    test('number of items when group filter is selected and group financial data is not null', () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(true);
      when(() => companyGroup1.financialSummary).thenReturn(financialSummary);
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);

      //when
      await presenter.loadDashboardData();
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), financialSummary);
      expect(presenter.getItemAtIndex(1), company1);
    });
  });

  group('tests for filtering company list', () {
    test('performing a search with no results', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => groupDashboardData.companies).thenReturn([]);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      presenter.performSearch("non existent company id");

      //then
      expect(presenter.getSearchText(), "non existent company id");
      verifyInOrder([() => view.updateCompanyList()]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('performing search successfully', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      presenter.performSearch("test2");

      //then
      expect(presenter.getSearchText(), "test2");
      expect(presenter.getNumberOfRows(), 1);
      expect(presenter.getItemAtIndex(0), company2);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('clearing search filter', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadDashboardData();
      presenter.performSearch("test2");
      _clearInteractionsOnAllMocks();

      //when
      presenter.clearSearchSelection();

      //then
      expect(presenter.getSearchText(), "");
      expect(presenter.getNumberOfRows(), 2);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('selecting a company group filter shows the company list and financial summary fot that group', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(true);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => companyGroup1.financialSummary).thenReturn(financialSummary);
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), financialSummary);
      expect(presenter.getItemAtIndex(1), company1);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('clearing company group filter selection', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadDashboardData();
      presenter.selectGroupAtIndex(0);
      _clearInteractionsOnAllMocks();

      //when
      presenter.clearGroupSelection();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('test applying both search and company group filter', () async {
      //given
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.shouldShowFinancialData()).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      presenter.performSearch("test2");
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 0);
      verifyInOrder([
        () => view.updateCompanyList(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for selecting company and viewing approvals', () {
    test('number of items when there are no companies', () async {
      when(() => mockDashboardDataProvider.isLoading).thenReturn(false);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => groupDashboardData.financialSummary).thenReturn(financialSummary);
      when(() => groupDashboardData.groups).thenReturn([]);
      await presenter.loadDashboardData();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectCompany(company1);

      //then
      verifyInOrder([
        () => mockCompanySelector.selectCompanyForCurrentUser(company1),
        () => view.goToCompanyDashboardScreen(company1),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('test going to approvals screen', () async {
      //when
      presenter.showAggregatedApprovals();

      //then
      verifyInOrder([
        () => view.goToApprovalsListScreen(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for getters', () {
    test('get profile image url', () async {
      //given
      var user = MockUser();
      when(() => user.profileImageUrl).thenReturn("someurl.com");
      when(() => mockCurrentUserProvider.getCurrentUser()).thenReturn(user);

      //when
      var profileImageUrl = presenter.getProfileImageUrl();

      //then
      expect(profileImageUrl, "someurl.com");
      verifyInOrder([
        () => mockCurrentUserProvider.getCurrentUser(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('should not show company groups if there are no groups', () async {
      //given
      var groupDashboardData = MockGroupDashboardData();
      when(() => groupDashboardData.groups).thenReturn([]);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      await presenter.loadDashboardData();

      //when
      var shouldShowGroups = presenter.shouldShowCompanyGroupsFilter();

      //then
      expect(shouldShowGroups, false);
    });

    test('should not show company groups if there are no groups', () async {
      //given
      var groupDashboardData = MockGroupDashboardData();
      when(() => groupDashboardData.groups).thenReturn([MockCompanyGroup()]);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      await presenter.loadDashboardData();

      //when
      var shouldShowGroups = presenter.shouldShowCompanyGroupsFilter();

      //then
      expect(shouldShowGroups, true);
    });

    test('getting total approval count', () async {
      //given
      when(() => company1.approvalCount).thenReturn(5);
      when(() => company2.approvalCount).thenReturn(13);
      when(() => groupDashboardData.companies).thenReturn([company1, company2]);
      when(() => mockDashboardDataProvider.get()).thenAnswer((_) => Future.value(groupDashboardData));
      await presenter.loadDashboardData();

      //when
      var totalApprovalCount = presenter.getApprovalCount();

      //then
      expect(totalApprovalCount, 18);
    });
  });
}
