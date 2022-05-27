import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/dashboard/ui/my_portal/presenters/my_portal_presenter.dart';
import 'package:wallpost/dashboard/ui/my_portal/view_contracts/my_portal_view.dart';
import 'package:wallpost/approvals/entities/Approvals.dart';
import 'package:wallpost/dashboard_core/services/approvals_provider.dart';
import '../../../_mocks/mock_company.dart';

class MockPortalView extends Mock implements MyPortalView {}

class MockApprovalsProvider extends Mock implements SelectedCompanyApprovalsListProvider {}

class MockCurrentUserProvider extends Mock implements CurrentUserProvider {}

class MockApprovals extends Mock implements Approvals {}

class MockApprovalItem extends Mock implements Approval {}


void main() {
  var view = MockPortalView();
  var mockApprovalsProvider = MockApprovalsProvider();
  var mockCurrentUserProvider = MockCurrentUserProvider();

  late MyPortalPresenter presenter;

  var mockCompany = MockCompany();
  var emptyApprovals = MockApprovals();
  var approvals = MockApprovals();
  var approval1 = MockApprovalItem();
  var approval2 = MockApprovalItem();

  List<Approval> _approvalsList = [approval1, approval2];

  setUpAll(() {
    when(() => approval1.id).thenReturn(1);
    when(() => approval2.id).thenReturn(2);
    when(() => approval1.companyId).thenReturn(1);
    when(() => approval2.companyId).thenReturn(2);
    when(() => approvals.approvals).thenReturn(_approvalsList);
  });

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockApprovalsProvider);
    clearInteractions(mockCurrentUserProvider);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockApprovalsProvider);
    verifyNoMoreInteractions(mockCurrentUserProvider);
  }

  setUp(() {
    _resetAllMockInteractions();
    presenter = MyPortalPresenter.initWith(
      view,
      mockCurrentUserProvider,
      mockApprovalsProvider,
    );
  });

  test('retrieving approvals failed', () async {
    //given
    when(() => mockApprovalsProvider.isLoading).thenReturn(false);
    when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
    when(() => mockApprovalsProvider.getNext()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadApprovals();

    //then
    verifyInOrder([
      () => mockApprovalsProvider.isLoading,
      () => mockApprovalsProvider.didReachListEnd,
      () => mockApprovalsProvider.getNext(),
      () => view.showErrorMessage(
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving approvals Successfully with empty list', () async {
    //given
    when(() => mockApprovalsProvider.isLoading).thenReturn(false);
    when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
    when(() => emptyApprovals.approvals).thenReturn([]);
    when(() => mockApprovalsProvider.actionsCount).thenReturn(0);

    when(() => mockApprovalsProvider.getNext())
        .thenAnswer((_) => Future.value(emptyApprovals));

    //when
    await presenter.loadApprovals();

    //then
    verifyInOrder([
      () => mockApprovalsProvider.isLoading,
      () => mockApprovalsProvider.didReachListEnd,
      () => mockApprovalsProvider.getNext(),
      () => view.onDidLoadData(),
      () => view.onDidLoadApprovals(emptyApprovals),
      () => mockApprovalsProvider.actionsCount,
      () => view.onDidLoadActionsCount(0)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });


  test(
      'retrieving companies successfully ',
          () async {
        //given
            when(() => mockApprovalsProvider.isLoading).thenReturn(false);
            when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
            when(() => approvals.approvals).thenReturn(_approvalsList);
            when(() => mockApprovalsProvider.actionsCount).thenReturn(2);

            when(() => mockApprovalsProvider.getNext())
                .thenAnswer((_) => Future.value(approvals));
        //when
        await presenter.loadApprovals();

        //then
        verifyInOrder([
              () => mockApprovalsProvider.isLoading,
              () => mockApprovalsProvider.didReachListEnd,
              () => mockApprovalsProvider.getNext(),
              () => view.onDidLoadData(),
              () => view.onDidLoadApprovals(approvals),
              () => mockApprovalsProvider.actionsCount,
              () => view.onDidLoadActionsCount(2)
        ]);
        _verifyNoMoreInteractionsOnAllMocks();
      });

}
