import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/leave/leave_detail/entities/leave_detail.dart';
import 'package:wallpost/leave/leave_detail/services/leave_detail_provider.dart';
import 'package:wallpost/leave/leave_detail/ui/presenters/leave_detail_presenter.dart';
import 'package:wallpost/leave/leave_detail/ui/view_contracts/leave_detail_view.dart';

import '../../../_mocks/mock_network_adapter.dart';

class MockLeaveDetailView extends Mock implements LeaveDetailView {}

class MockLeaveDetailProvider extends Mock implements LeaveDetailProvider {}

class MockLeaveDetail extends Mock implements LeaveDetail {}

void main() {
  late MockLeaveDetailView view;
  late MockLeaveDetailProvider detailProvider;
  late LeaveDetailPresenter presenter;

  setUp(() {
    view = MockLeaveDetailView();
    detailProvider = MockLeaveDetailProvider();
    presenter = LeaveDetailPresenter.initWith("someCompanyId", "someLeaveId", view, detailProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(detailProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(detailProvider);
  }

  test('does nothing when the provider is loading', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadDetail();

    //then
    verifyInOrder([
      () => detailProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load detail', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadDetail();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => detailProvider.isLoading,
      () => view.showLoader(),
      () => detailProvider.get("someLeaveId"),
      () => view.onDidFailToLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('loading detail successfully', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockLeaveDetail()));

    //when
    await presenter.loadDetail();

    //then
    verifyInOrder([
      () => detailProvider.isLoading,
      () => view.showLoader(),
      () => detailProvider.get("someLeaveId"),
      () => view.onDidLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('error is reset on reload', () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadDetail();
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockLeaveDetail()));

    //when
    await presenter.loadDetail();

    //then
    expect(presenter.errorMessage, null);
  });

  //MARK: Tests for approval and rejection

  test("initiating approval", () async {
    //given
    var leave = MockLeaveDetail();
    when(() => leave.applicantName).thenReturn("some name");
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    await presenter.loadDetail();
    _clearAllInteractions();

    //when
    presenter.initiateApproval();

    //then
    verifyInOrder([
      () => view.processApproval("someCompanyId", "someLeaveId", "some name"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("initiating rejection", () async {
    //given
    var leave = MockLeaveDetail();
    when(() => leave.applicantName).thenReturn("some name");
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    await presenter.loadDetail();
    _clearAllInteractions();

    //when
    presenter.initiateRejection();

    //then
    verifyInOrder([
      () => view.processRejection("someCompanyId", "someLeaveId", "some name"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully approving or rejecting reloads the data", () async {
    //given
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(MockLeaveDetail()));

    //when
    await presenter.onDidProcessApprovalOrRejection(true);

    //then
    expect(presenter.didProcessApprovalOrRejection, true);
    verifyInOrder([
      () => detailProvider.isLoading,
      () => view.showLoader(),
      () => detailProvider.get("someLeaveId"),
      () => view.onDidLoadDetails(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("does not reload data when processing approval or rejection with null or false", () async {
    presenter.onDidProcessApprovalOrRejection(null);
    expect(presenter.didProcessApprovalOrRejection, false);
    _verifyNoMoreInteractionsOnAllMocks();

    presenter.onDidProcessApprovalOrRejection(false);
    expect(presenter.didProcessApprovalOrRejection, false);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for getters

  test('should not show approval actions when not coming from approvals list', () async {
    presenter = LeaveDetailPresenter.initWith(
      "someCompanyId",
      "someLeaveId",
      view,
      detailProvider,
      didLaunchDetailScreenForApproval: false,
    );

    expect(presenter.shouldShowApprovalActions(), false);
  });

  test(
      'should not show approval actions when coming from approvals list'
      'but the approval status is not pending', () async {
    presenter = LeaveDetailPresenter.initWith(
      "someCompanyId",
      "someLeaveId",
      view,
      detailProvider,
      didLaunchDetailScreenForApproval: true,
    );
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.isPendingApproval()).thenReturn(false);
    await presenter.loadDetail();

    expect(presenter.shouldShowApprovalActions(), false);
  });

  test(
      'should show approval actions when coming from approvals list'
      'and the approval status is not pending', () async {
    presenter = LeaveDetailPresenter.initWith(
      "someCompanyId",
      "someLeaveId",
      view,
      detailProvider,
      didLaunchDetailScreenForApproval: true,
    );
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.isPendingApproval()).thenReturn(true);
    await presenter.loadDetail();

    expect(presenter.shouldShowApprovalActions(), true);
  });

  test('get title', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.applicantName).thenReturn("Some name");
    await presenter.loadDetail();

    expect(presenter.getTitle(), "Some name");
  });

  test('get leave type', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.leaveType).thenReturn("Some type");
    await presenter.loadDetail();

    expect(presenter.getLeaveType(), "Some type");
  });

  test('get start date', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.startDate).thenReturn(DateTime(2022, 8, 20));
    await presenter.loadDetail();

    expect(presenter.getLeaveStartDate(), "20 Aug 2022");
  });

  test('get end date', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.endDate).thenReturn(DateTime(2022, 8, 22));
    await presenter.loadDetail();

    expect(presenter.getLeaveEndDate(), "22 Aug 2022");
  });

  test('get total  days', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.totalLeaveDays).thenReturn(4);
    await presenter.loadDetail();

    expect(presenter.getTotalDays(), "4");
  });

  test('get total paid days', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.paidDays).thenReturn(3);
    await presenter.loadDetail();

    expect(presenter.getTotalPaidDays(), "3");
  });

  test('get total unpaid days', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.unPaidDays).thenReturn(1);
    await presenter.loadDetail();

    expect(presenter.getTotalUnpaidDays(), "1");
  });

  test('get leave reason', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.leaveReason).thenReturn("some leave reason");
    await presenter.loadDetail();

    expect(presenter.getLeaveReason(), "some leave reason");
  });

  test('get attachment url', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.attachmentUrl).thenReturn("some attachment url");
    await presenter.loadDetail();

    expect(presenter.getAttachmentUrl(), "some attachment url");
  });

  test('status is null when leave is approved', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.isApproved()).thenReturn(true);
    await presenter.loadDetail();

    expect(presenter.getStatus(), null);
  });

  test('get status when status is pending and approver names are available', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.isApproved()).thenReturn(false);
    when(() => leave.isPendingApproval()).thenReturn(true);
    when(() => leave.pendingWithUsers).thenReturn("Some Username");
    when(() => leave.statusString).thenReturn("Pending");
    await presenter.loadDetail();

    expect(presenter.getStatus(), "Pending with Some Username");
  });

  test('get status when status is pending and approver names are not available', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.isApproved()).thenReturn(false);
    when(() => leave.isPendingApproval()).thenReturn(true);
    when(() => leave.pendingWithUsers).thenReturn(null);
    when(() => leave.statusString).thenReturn("Pending");
    await presenter.loadDetail();

    expect(presenter.getStatus(), "Pending");
  });

  test('get status for all other leave statuses', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    when(() => leave.isApproved()).thenReturn(false);
    when(() => leave.isPendingApproval()).thenReturn(false);
    when(() => leave.statusString).thenReturn("Some Status");
    await presenter.loadDetail();

    expect(presenter.getStatus(), "Some Status");
  });

  test('get status color', () async {
    var leave = MockLeaveDetail();
    when(() => detailProvider.isLoading).thenReturn(false);
    when(() => detailProvider.get(any())).thenAnswer((_) => Future.value(leave));
    await presenter.loadDetail();

    when(() => leave.isPendingApproval()).thenReturn(true);
    expect(presenter.getStatusColor(), AppColors.yellow);

    when(() => leave.isPendingApproval()).thenReturn(false);
    expect(presenter.getStatusColor(), AppColors.red);
  });
}
