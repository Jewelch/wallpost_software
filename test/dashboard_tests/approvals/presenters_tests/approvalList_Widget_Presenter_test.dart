// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
// import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
// import 'package:wallpost/approvals/entities/approval.dart';
// import 'package:wallpost/approvals/services/approval_list_provider.dart';
// import 'package:wallpost/approvals/ui/presenters/approval_list_widget_presenter.dart';
// import 'package:wallpost/approvals/ui/view_contracts/approval_list_widget_view.dart';
//
// class MockApprovalListWidgetView extends Mock
//     implements ApprovalListWidgetView {}
//
// class MockApprovalsProvider extends Mock implements ApprovalListProvider {}
//
// class MockCurrentUserProvider extends Mock implements CurrentUserProvider {}
//
// class MockApprovalItem extends Mock implements Approval {}
//
// void main() {
//   var view = MockApprovalListWidgetView();
//   var mockApprovalsProvider = MockApprovalsProvider();
//   var mockCurrentUserProvider = MockCurrentUserProvider();
//
//   late ApprovalListWidgetPresenter presenter;
//
//   var approval1 = MockApprovalItem();
//   var approval2 = MockApprovalItem();
//   var approvals = [approval1, approval2];
//
//   List<Approval> _approvalsList = [approval1, approval2];
//
//   setUpAll(() {
//     when(() => approval1.id).thenReturn("1");
//     when(() => approval2.id).thenReturn("2");
//     when(() => approval1.companyId).thenReturn("1");
//     when(() => approval2.companyId).thenReturn("2");
//   });
//
//   void _resetAllMockInteractions() {
//     clearInteractions(view);
//     clearInteractions(mockApprovalsProvider);
//     clearInteractions(mockCurrentUserProvider);
//   }
//
//   void _verifyNoMoreInteractionsOnAllMocks() {
//     verifyNoMoreInteractions(view);
//     verifyNoMoreInteractions(mockApprovalsProvider);
//     verifyNoMoreInteractions(mockCurrentUserProvider);
//   }
//
//   void _clearAllInteractions() {
//     clearInteractions(view);
//     clearInteractions(mockApprovalsProvider);
//   }
//
//   setUp(() {
//     _resetAllMockInteractions();
//     presenter = ApprovalListWidgetPresenter.initWith(
//       view,
//       mockApprovalsProvider,
//     );
//   });
//
//   test('retrieving approvals failed', () async {
//     //given
//     when(() => mockApprovalsProvider.isLoading).thenReturn(false);
//     when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
//     when(() => mockApprovalsProvider.getNext()).thenAnswer(
//       (realInvocation) => Future.error(InvalidResponseException()),
//     );
//
//     //when
//     await presenter.loadApprovals();
//
//     //then
//     verifyInOrder([
//       () => mockApprovalsProvider.isLoading,
//       () => mockApprovalsProvider.didReachListEnd,
//       () => view.onLoad(),
//       () => mockApprovalsProvider.getNext(),
//       () => view.showErrorMessage(
//           "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('retrieving approvals Successfully with empty list', () async {
//     //given
//     when(() => mockApprovalsProvider.isLoading).thenReturn(false);
//     when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
//     when(() => mockApprovalsProvider.actionsCount).thenReturn(0);
//
//     when(() => mockApprovalsProvider.getNext())
//         .thenAnswer((_) => Future.value([]));
//
//     //when
//     await presenter.loadApprovals();
//
//     //then
//     verifyInOrder([
//       () => mockApprovalsProvider.isLoading,
//       () => mockApprovalsProvider.didReachListEnd,
//       () => view.onLoad(),
//       () => mockApprovalsProvider.getNext(),
//       () => view.onDidLoadData(),
//       () => mockApprovalsProvider.actionsCount,
//       () => view.onDidLoadActionsCount(0),
//       () => view.onDidLoadApprovals([])
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('retrieving approvals successfully ', () async {
//     //given
//     when(() => mockApprovalsProvider.isLoading).thenReturn(false);
//     when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
//     when(() => mockApprovalsProvider.actionsCount).thenReturn(2);
//
//     when(() => mockApprovalsProvider.getNext())
//         .thenAnswer((_) => Future.value(approvals));
//     //when
//     await presenter.loadApprovals();
//
//     //then
//     verifyInOrder([
//       () => mockApprovalsProvider.isLoading,
//       () => mockApprovalsProvider.didReachListEnd,
//       () => view.onLoad(),
//       () => mockApprovalsProvider.getNext(),
//       () => view.onDidLoadData(),
//       () => mockApprovalsProvider.actionsCount,
//       () => view.onDidLoadActionsCount(2),
//       () => view.onDidLoadApprovals(approvals),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('failure to load the next list of items', () async {
//     //given
//     when(() => mockApprovalsProvider.isLoading).thenReturn(false);
//     when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
//     when(() => mockApprovalsProvider.actionsCount).thenReturn(2);
//     when(() => mockApprovalsProvider.getNext())
//         .thenAnswer((_) => Future.value(approvals));
//     await presenter.loadApprovals();
//     when(() => mockApprovalsProvider.getNext())
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//     _clearAllInteractions();
//
//     //when
//     await presenter.loadApprovals();
//
//     expect(presenter.errorMessage,
//         "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
//     //then
//     verifyInOrder([
//       () => mockApprovalsProvider.isLoading,
//       () => mockApprovalsProvider.didReachListEnd,
//       () => mockApprovalsProvider.getNext(),
//       () => view.showErrorMessage(presenter.errorMessage)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//
//   test('successfully loading the next list of items', () async {
//     //given
//     when(() => mockApprovalsProvider.isLoading).thenReturn(false);
//     when(() => mockApprovalsProvider.didReachListEnd).thenReturn(false);
//     when(() => mockApprovalsProvider.actionsCount).thenReturn(2);
//     when(() => mockApprovalsProvider.getNext())
//         .thenAnswer((_) => Future.value(approvals));
//     await presenter.loadApprovals();
//     when(() => mockApprovalsProvider.getNext())
//         .thenAnswer((_) => Future.value(approvals));
//     _clearAllInteractions();
//
//     //when
//     await presenter.loadApprovals();
//
//     //then
//     verifyInOrder([
//       () => mockApprovalsProvider.isLoading,
//       () => mockApprovalsProvider.didReachListEnd,
//       () => mockApprovalsProvider.getNext(),
//       () => view.onDidLoadData(),
//       () => mockApprovalsProvider.actionsCount,
//       () => view.onDidLoadActionsCount(2),
//       () => view.onDidLoadApprovals(approvals),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
// }
