import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/aggregated_approvals_list/services/aggregated_approvals_list_provider.dart';
import 'package:wallpost/aggregated_approvals_list/ui/presenters/aggregated_approvals_list_presenter.dart';
import 'package:wallpost/aggregated_approvals_list/ui/view_contracts/aggregated_approvals_list_view.dart';

class MockAggregatedApproval extends Mock implements AggregatedApproval {}

class MockAggregatedApprovalsListView extends Mock implements AggregatedApprovalsListView {}

class MockAggregatedApprovalsProvider extends Mock implements AggregatedApprovalsListProvider {}

void main() {
  var view = MockAggregatedApprovalsListView();
  var approvalsProvider = MockAggregatedApprovalsProvider();
  late AggregatedApprovalsListPresenter presenter;

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(approvalsProvider);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(approvalsProvider);
  }

  setUp(() {
    _resetAllMockInteractions();
    presenter = AggregatedApprovalsListPresenter.initWith(view, approvalsProvider);
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

  test('successfully getting approvals', () async {
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
      () => view.onDidLoadApprovals(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting company and module names', () async {
    //given
    var approval1 = MockAggregatedApproval();
    when(() => approval1.companyName).thenReturn("Company One");
    when(() => approval1.module).thenReturn("hr");
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval2.module).thenReturn("finance");
    var approval3 = MockAggregatedApproval();
    when(() => approval3.companyName).thenReturn("C Three");
    when(() => approval3.module).thenReturn("hr");
    var approvals = [approval1, approval2, approval3];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //then
    expect(presenter.getCompanyNames(), ["All Companies", "Company One", "Company Two", "C Three"]);
    expect(presenter.getModuleNames(), ["All Modules", "hr", "finance"]);
  });

  test('applying company name filter', () async {
    //given
    var approval1 = MockAggregatedApproval();
    when(() => approval1.companyName).thenReturn("Company One");
    when(() => approval1.module).thenReturn("hr");
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval2.module).thenReturn("finance");
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
      () => view.onDidLoadApprovals(),
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
      () => view.onDidLoadApprovals(),
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
    when(() => approval1.module).thenReturn("hr");
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval2.module).thenReturn("finance");
    var approval3 = MockAggregatedApproval();
    when(() => approval3.companyName).thenReturn("C Three");
    when(() => approval3.module).thenReturn("hr");
    var approvals = [approval1, approval2, approval3];
    when(() => approvalsProvider.isLoading).thenReturn(false);
    when(() => approvalsProvider.getAllApprovals()).thenAnswer((_) => Future.value(approvals));
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.filter(moduleName: "hr");

    //then
    expect(presenter.getSelectedModuleName(), "hr");
    expect(presenter.getNumberOfRows(), 2);
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval3);
    verifyInOrder([
      () => view.onDidLoadApprovals(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();

    //when
    _resetAllMockInteractions();
    presenter.filter(moduleName: "finance");

    //then
    expect(presenter.getSelectedModuleName(), "finance");
    expect(presenter.getNumberOfRows(), 1);
    expect(presenter.getItemAtIndex(0), approval2);
    verifyInOrder([
      () => view.onDidLoadApprovals(),
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
    when(() => approval1.module).thenReturn("hr");
    var approval2 = MockAggregatedApproval();
    when(() => approval2.companyName).thenReturn("Company Two");
    when(() => approval2.module).thenReturn("finance");
    var approval3 = MockAggregatedApproval();
    when(() => approval3.companyName).thenReturn("C Three");
    when(() => approval3.module).thenReturn("hr");
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
}
