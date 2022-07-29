import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';
import 'package:wallpost/approvals_list/services/approvals_aggregated_list_provider.dart';
import 'package:wallpost/approvals_list/ui/presenters/approvals_aggregated_list_presenter.dart';
import 'package:wallpost/approvals_list/ui/view_contracts/approvals_list_view.dart';

class MockApprovalsAggregatedListView extends Mock
    implements ApprovalsListView {}

class MockApprovalsAggregatedListProvider extends Mock
    implements ApprovalsAggregatedListProvider {}

class MockApprovalAggregated extends Mock implements ApprovalAggregated {}


void main() {
  var view = MockApprovalsAggregatedListView();
  var mockApprovalsAggregatedListProvider =
  MockApprovalsAggregatedListProvider();
  late ApprovalsListPresenter presenter;

  var approvalAggregated1 = MockApprovalAggregated();
  var approvalAggregated2 = MockApprovalAggregated();


  setUpAll(() {
    when(() => approvalAggregated1.companyName).thenReturn("company 1");
    when(() => approvalAggregated1.companyId).thenReturn(1);
    when(() => approvalAggregated1.approvalCount).thenReturn(4);
    when(() => approvalAggregated1.module).thenReturn("module 1");
    when(() => approvalAggregated2.companyName).thenReturn("company 2");
    when(() => approvalAggregated2.companyId).thenReturn(2);
    when(() => approvalAggregated2.approvalCount).thenReturn(2);
    when(() => approvalAggregated2.module).thenReturn("module 2");

  });

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockApprovalsAggregatedListProvider);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockApprovalsAggregatedListProvider);
  }

  setUp(() {
    _resetAllMockInteractions();
    presenter = ApprovalsListPresenter.initWith(
      view,
      mockApprovalsAggregatedListProvider,
    );
  });

  test('retrieving aggregated approvals failed', () async {
    //given
    when(() => mockApprovalsAggregatedListProvider.isLoading).thenReturn(false);
    when(() => mockApprovalsAggregatedListProvider.get()).thenAnswer(
          (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadApprovalsList();

    //then
    verifyInOrder([
          () => mockApprovalsAggregatedListProvider.isLoading,
          () => view.onLoad(),
          () => mockApprovalsAggregatedListProvider.get(),
          () => view.showErrorMessage(
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving aggregated approvals successfully with empty data',
          () async {
        //given
        when(() => mockApprovalsAggregatedListProvider.isLoading).thenReturn(false);
        when(() => mockApprovalsAggregatedListProvider.get())
            .thenAnswer((_) => Future.value([]));

        //when
        await presenter.loadApprovalsList();

        //then
        verifyInOrder([
              () => mockApprovalsAggregatedListProvider.isLoading,
              () => view.onLoad(),
              () => mockApprovalsAggregatedListProvider.get(),
              () => view.onDidLoadData(),
              () => view.onDidLoadCompanies([" All Companies "]),
              () => view.onDidLoadModules([" All Modules "]),
              () => view
              .showErrorMessage("There are no approvals.\n\nTap here to reload."),
        ]);
        _verifyNoMoreInteractionsOnAllMocks();
      });


  test(
      'retrieving aggregated approvals successfully ',
          () async {
        //given
        when(() => mockApprovalsAggregatedListProvider.isLoading).thenReturn(false);
        when(() => mockApprovalsAggregatedListProvider.get())
            .thenAnswer((_) => Future.value([approvalAggregated1,approvalAggregated2]));
        when(() => approvalAggregated1.companyId).thenReturn(1);
        when(() => approvalAggregated2.companyId).thenReturn(2);

        //when
        await presenter.loadApprovalsList();

        //then
        verifyInOrder([
              () => mockApprovalsAggregatedListProvider.isLoading,
              () => view.onLoad(),
              () => mockApprovalsAggregatedListProvider.get(),
              () => view.onDidLoadData(),
              () => view.onDidLoadCompanies([" All Companies ","company 1","company 2"]),
              () => view.onDidLoadModules([" All Modules ","module 1","module 2"]),
              ()=> view.onDidLoadApprovals([approvalAggregated1,approvalAggregated2])

        ]);
        _verifyNoMoreInteractionsOnAllMocks();
      });


  test('performing search successfully', () async {
    //given
    when(() => mockApprovalsAggregatedListProvider.isLoading).thenReturn(false);
    when(() => mockApprovalsAggregatedListProvider.get())
        .thenAnswer((_) => Future.value([approvalAggregated1,approvalAggregated2]));
    when(() => approvalAggregated1.companyId).thenReturn(1);
    when(() => approvalAggregated2.companyId).thenReturn(2);
    await presenter.loadApprovalsList();
    _resetAllMockInteractions();

    //when
    presenter.filter(null,"company 1");
    presenter.filter(null,"company 2");

    //then
    verifyInOrder([
          () => view.onDidLoadApprovals([approvalAggregated1]),
          () => view.onDidLoadApprovals([approvalAggregated2]),

    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

}
