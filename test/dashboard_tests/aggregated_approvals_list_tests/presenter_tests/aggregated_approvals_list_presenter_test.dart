import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/services/aggregated_approvals_list_provider.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/ui/presenters/aggregated_approvals_list_presenter.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/ui/view_contracts/aggregated_approvals_list_view.dart';

import '../../../_mocks/mock_notification_center.dart';
import '../../../_mocks/mock_notification_observer.dart';
import '../mocks.dart';

class MockAggregatedApproval extends Mock implements AggregatedApproval {}

class MockAggregatedApprovalsListView extends Mock implements AggregatedApprovalsListView {}

class MockAggregatedApprovalsProvider extends Mock implements AggregatedApprovalsListProvider {}

void main() {
  var view = MockAggregatedApprovalsListView();
  var approvalsProvider = MockAggregatedApprovalsProvider();
  late MockNotificationCenter notificationCenter;
  late AggregatedApprovalsListPresenter presenter;

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(approvalsProvider);
    clearInteractions(notificationCenter);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(approvalsProvider);
    verifyNoMoreInteractions(notificationCenter);
  }

  setUpAll(() {
    registerFallbackValue(MockNotificationObserver());
  });

  setUp(() {
    notificationCenter = MockNotificationCenter();
    presenter = AggregatedApprovalsListPresenter.initWith(view, approvalsProvider, notificationCenter);
    _resetAllMockInteractions();
  });

  test('starts listening to notifications on initialization', () async {
    //given
    presenter = AggregatedApprovalsListPresenter.initWith(view, approvalsProvider, notificationCenter);

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
      () => notificationCenter.removeObserverFromAllChannels(key: "aggregatedApprovalsList"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('does nothing when the provider is loading', () async {
    //given
    when(() => approvalsProvider.isLoading).thenReturn(true);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadApprovalsList();

    //then
    verifyInOrder([
      () => approvalsProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to get approvals', () async {
    //given
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadApprovalsList();

    //then
    verifyInOrder([
      () => approvalsProvider.isLoading,
      () => view.showLoader(),
      () => approvalsProvider.getAllApprovals(),
      () =>
          view.showErrorMessage("Oops! Looks like something has gone wrong. Please try again.\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully getting an empty list of approvals', () async {
    //given
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value([]));

    //when
    await presenter.loadApprovalsList();

    //then
    verifyInOrder([
      () => approvalsProvider.isLoading,
      () => view.showLoader(),
      () => approvalsProvider.getAllApprovals(),
      () => view.showErrorMessage("There are no pending approvals.\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully getting approvals for all companies', () async {
    //given
    var approval1 = MockAggregatedApproval();
    var approval2 = MockAggregatedApproval();
    var approvals = [approval1, approval2];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));

    //when
    await presenter.loadApprovalsList();

    //then
    expect(presenter.getNumberOfRows(), 2);
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval2);
    verifyInOrder([
      () => approvalsProvider.isLoading,
      () => view.showLoader(),
      () => approvalsProvider.getAllApprovals(),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully getting approvals for given company id', () async {
    //given
    var approval1 = MockAggregatedApproval();
    var approval2 = MockAggregatedApproval();
    var approvals = [approval1, approval2];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals(companyId: any(named: "companyId")))
        .thenAnswer((_) => Future.value(approvals));
    presenter = AggregatedApprovalsListPresenter.initWith(
      view,
      approvalsProvider,
      notificationCenter,
      companyId: "someCompanyId",
    );
    _resetAllMockInteractions();

    //when
    await presenter.loadApprovalsList();

    //then
    expect(presenter.getNumberOfRows(), 2);
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval2);
    verifyInOrder([
      () => approvalsProvider.isLoading,
      () => view.showLoader(),
      () => approvalsProvider.getAllApprovals(companyId: "someCompanyId"),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('should show company filter when showing approvals for all companies', () async {
    expect(presenter.shouldShowCompanyFilter(), true);
  });

  test('should show company filter when showing approvals for selected company', () async {
    presenter = AggregatedApprovalsListPresenter.initWith(
      view,
      approvalsProvider,
      notificationCenter,
      companyId: "someCompanyId",
    );

    expect(presenter.shouldShowCompanyFilter(), false);
  });

  test('getting company and module names', () async {
    //given
    var approval1 = MockAggregatedApproval();
    when(() => approval1.companyName).thenReturn("Company One");
    when(() => approval1.module).thenReturn(Module.Hr);
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval2.module).thenReturn(Module.Finance);
    var approval3 = MockAggregatedApproval();
    when(() => approval3.companyName).thenReturn("C Three");
    when(() => approval3.module).thenReturn(Module.Hr);
    var approvals = [approval1, approval2, approval3];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //then
    expect(presenter.getCompanyNames(), ["All Companies", "Company One", "Company Two", "C Three"]);
    expect(presenter.getModuleNames(), ["All Modules", "HR", "Finance"]);
  });

  test('applying company name filter', () async {
    //given
    var approval1 = MockAggregatedApproval();
    when(() => approval1.companyName).thenReturn("Company One");
    when(() => approval1.module).thenReturn(Module.Hr);
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval1.module).thenReturn(Module.Finance);
    var approvals = [approval1, approval2];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.filter(companyName: "Company One");

    //then
    expect(presenter.getSelectedCompanyName(), "Company One");
    expect(presenter.getNumberOfRows(), 1);
    expect(presenter.getItemAtIndex(0), approval1);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();

    //when
    _resetAllMockInteractions();
    presenter.filter(companyName: "Company Two");

    //then
    expect(presenter.getSelectedCompanyName(), "Company Two");
    expect(presenter.getNumberOfRows(), 1);
    expect(presenter.getItemAtIndex(0), approval2);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();

    //when
    _resetAllMockInteractions();
    presenter.filter(companyName: "Invalid Name");

    //then
    expect(presenter.getNumberOfRows(), 0);
    expect(presenter.getSelectedCompanyName(), "Invalid Name");
    verifyInOrder([
      () => view.showNoMatchingResultsMessage("There are no approvals that match\nthe selected filters."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('applying module filter', () async {
    //given
    var approval1 = MockAggregatedApproval();
    when(() => approval1.companyName).thenReturn("Company One");
    when(() => approval1.module).thenReturn(Module.Hr);
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval2.module).thenReturn(Module.Finance);
    var approval3 = MockAggregatedApproval();
    when(() => approval3.companyName).thenReturn("C Three");
    when(() => approval3.module).thenReturn(Module.Hr);
    var approvals = [approval1, approval2, approval3];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.filter(moduleName: Module.Hr.toReadableString());

    //then
    expect(presenter.getSelectedModuleName(), "HR");
    expect(presenter.getNumberOfRows(), 2);
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval3);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();

    //when
    _resetAllMockInteractions();
    presenter.filter(moduleName: Module.Finance.toReadableString());

    //then
    expect(presenter.getSelectedModuleName(), Module.Finance.toReadableString());
    expect(presenter.getNumberOfRows(), 1);
    expect(presenter.getItemAtIndex(0), approval2);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();

    //when
    _resetAllMockInteractions();
    presenter.filter(moduleName: "Invalid Module");

    //then
    expect(presenter.getSelectedModuleName(), "Invalid Module");
    expect(presenter.getNumberOfRows(), 0);
    verifyInOrder([
      () => view.showNoMatchingResultsMessage("There are no approvals that match\nthe selected filters."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('filters are reset before loading data', () async {
    //given
    var approval1 = MockAggregatedApproval();
    when(() => approval1.companyName).thenReturn("Company One");
    when(() => approval1.module).thenReturn(Module.Hr);
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval1.module).thenReturn(Module.Finance);
    var approval3 = MockAggregatedApproval();
    when(() => approval3.companyName).thenReturn("C Three");
    when(() => approval1.module).thenReturn(Module.Hr);
    var approvals = [approval1, approval2, approval3];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    presenter.filter(companyName: "Company One", moduleName: "hr");
    _resetAllMockInteractions();

    //when
    await presenter.loadApprovalsList();

    //then
    expect(presenter.getNumberOfRows(), 3);
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval2);
    expect(presenter.getItemAtIndex(2), approval3);
  });

  test("approval processing when number of approvals is invalid does nothing", () {
    presenter.didProcessApprovals(MockAggregatedApproval(), null);
    _verifyNoMoreInteractionsOnAllMocks();

    presenter.didProcessApprovals(MockAggregatedApproval(), 2.44);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "approval processing when all approvals in the aggregated"
      "approval are not processed, reduces the approval count and"
      "updates the list", () async {
    //given
    var approval = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[0]);
    var approvals = [approval];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.didProcessApprovals(approval, 5);

    //then
    expect(approval.approvalCount, 3);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "approval processing when all approvals in the aggregated"
      "approval are processed, removes the aggregated approval and"
      "updates the list", () async {
    //given
    var approval1 = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[0]);
    var approval2 = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[1]);
    var approvals = [approval1, approval2];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.didProcessApprovals(approval1, 8);

    //then
    expect(presenter.getNumberOfRows(), 1);
    expect(presenter.getItemAtIndex(0), approval2);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "setting count that makes the aggregated approval count negative"
      "removes the aggregated approval and updates the list", () async {
    //given
    var approval1 = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[0]);
    var approval2 = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[1]);
    var approvals = [approval1, approval2];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.didProcessApprovals(approval1, 4000);

    //then
    expect(presenter.getNumberOfRows(), 1);
    expect(presenter.getItemAtIndex(0), approval2);
    verifyInOrder([
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "approval processing when all approvals in all aggregated"
      "approval are processed", () async {
    //given
    var approval1 = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[0]);
    var approval2 = AggregatedApproval.fromJson(Mocks.aggregatedApprovalsResponse[1]);
    var approvals = [approval1, approval2];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    presenter.didProcessApprovals(approval1, 8);
    _resetAllMockInteractions();

    //when
    presenter.didProcessApprovals(approval2, 4);

    //then
    expect(presenter.getNumberOfRows(), 0);
    verifyInOrder([
      () => view.onDidProcessAllApprovals(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
