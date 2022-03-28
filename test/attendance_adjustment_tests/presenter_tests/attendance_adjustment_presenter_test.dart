import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_adjustment_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import 'attendance_list_presenter_test.dart';

class MockAttendanceAdjustmentView extends Mock implements AttendanceAdjustmentView {}

class MockAdjustedStatusProvider extends Mock implements AdjustedStatusProvider {}

class MockAttendanceAdjustmentSubmitter extends Mock implements AttendanceAdjustmentSubmitter {}

class MockAttendanceAdjustmentForm extends Mock implements AttendanceAdjustmentForm {}

class MockAdjustedStatusForm extends Mock implements AdjustedStatusForm {}

void main() {
  var view = MockAttendanceAdjustmentView();
  var attendanceListItem = MockAttendanceListItem();
  var adjustedStatusProvider = MockAdjustedStatusProvider();
  var attendanceAdjustmentSubmitter = MockAttendanceAdjustmentSubmitter();
  var selectedEmployeeProvider = MockEmployeeProvider();
  late AttendanceAdjustmentPresenter presenter;

  TimeOfDay adjustedTime = TimeOfDay(hour: 9, minute: 0);

  void _resetAllMocksAndSetupEmployeeProvider() {
    reset(view);
    reset(selectedEmployeeProvider);
    reset(adjustedStatusProvider);
    reset(attendanceAdjustmentSubmitter);

    when(() => selectedEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(MockEmployee());
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(selectedEmployeeProvider);
    verifyNoMoreInteractions(adjustedStatusProvider);
    verifyNoMoreInteractions(attendanceAdjustmentSubmitter);
  }

  setUpAll(() {
    registerFallbackValue(MockAdjustedStatusForm());
    registerFallbackValue(MockAttendanceAdjustmentForm());
  });

  setUp(() {
    _resetAllMocksAndSetupEmployeeProvider();
    when(() => attendanceListItem.date).thenReturn(DateTime.now());

    presenter = AttendanceAdjustmentPresenter.initWith(
      view,
      attendanceListItem,
      adjustedStatusProvider,
      attendanceAdjustmentSubmitter,
      selectedEmployeeProvider,
    );
  });

  //TODO test1 - sets punch in and out time to 00:00 at initialization if the punch in and punch out times are null
  //TODO test2 - sets punch in and out time to the actual punch in and punch out time at the time of initialization

  test('getting adjusted status when adjustedStatusProvider is loading does nothing ', () async {
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(true);

    //when
    await presenter.adjustPunchInTime(adjustedTime);

    //then
    verifyInOrder([
      () => adjustedStatusProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failed to get adjusted status when adjusting punch in time', () async {
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(false);
    when(() => adjustedStatusProvider.getAdjustedStatus(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.adjustPunchInTime(adjustedTime);

    //then
    verifyInOrder([
      () => adjustedStatusProvider.isLoading,
      () => view.showLoader(),
      () => adjustedStatusProvider.getAdjustedStatus(any()),
      () => view.hideLoader(),
      () => view.onDidLoadAdjustedStatus(),
      () => view.onGetAdjustedStatusFailed(
          'Getting adjusted status failed', InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting adjusted status when punch in time adjusted',() async{
    //given
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
            .thenAnswer((_) => Future.value(AttendanceStatus.Present));

    //when
      await presenter.adjustPunchInTime(adjustedTime);

      //then
      verifyInOrder([
        () => adjustedStatusProvider.isLoading,
        () => view.showLoader(),
        () => adjustedStatusProvider.getAdjustedStatus(any()),
        () => view.hideLoader(),
        () => view.onDidLoadAdjustedStatus(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failed to get adjusted status when adjusting punch out time', () async {
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(false);
    when(() => adjustedStatusProvider.getAdjustedStatus(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.adjustPunchOutTime(adjustedTime);

    //then
    verifyInOrder([
          () => adjustedStatusProvider.isLoading,
          () => view.showLoader(),
          () => adjustedStatusProvider.getAdjustedStatus(any()),
          () => view.hideLoader(),
          () => view.onDidLoadAdjustedStatus(),
          () => view.onGetAdjustedStatusFailed(
          'Getting adjusted status failed', InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting adjusted status when punch in time adjusted',() async{
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(false);
    when(() => adjustedStatusProvider.getAdjustedStatus(any()))
        .thenAnswer((_) => Future.value(AttendanceStatus.Present));

    //when
    await presenter.adjustPunchOutTime(adjustedTime);

    //then
    verifyInOrder([
          () => adjustedStatusProvider.isLoading,
          () => view.showLoader(),
          () => adjustedStatusProvider.getAdjustedStatus(any()),
          () => view.hideLoader(),
          () => view.onDidLoadAdjustedStatus(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Tests for submitting adjusted attendance_punch_in_out

  Future<void> _loadAdjustedStatusAndResetAllMocks() async {
    when(() => adjustedStatusProvider.isLoading).thenReturn(false);
    when(() => adjustedStatusProvider.getAdjustedStatus(any()))
        .thenAnswer((_) => Future.value(AttendanceStatus.Present));
    await presenter.adjustPunchInTime(adjustedTime);
    await presenter.adjustPunchOutTime(adjustedTime);
    _resetAllMocksAndSetupEmployeeProvider();
  }

  test('notifies view if reason is empty', () async {
    //given
    await _loadAdjustedStatusAndResetAllMocks();

    //when
    await presenter.submitAdjustment('');

    //then
    verifyInOrder([
      () => view.clearError(),
      () => view.notifyInvalidReason('Invalid reason'),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('notifies view if attendance_punch_in_out not adjusted', () async {
    //given
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);

    //when
    await presenter.submitAdjustment('some work');

    //then
    verifyInOrder([
      () => view.clearError(),
      () => view.notifyInvalidAdjustedStatus("Failed", "Attendance not adjusted"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('submitting adjusted attendance_punch_in_out when the adjustment submitter is loading does nothing ', () async {
    //given
    await _loadAdjustedStatusAndResetAllMocks();
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(true);

    //when
    await presenter.submitAdjustment('some work');

    //then
    verifyInOrder([
      () => view.clearError(),
      () => attendanceAdjustmentSubmitter.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failed to submit adjusted attendance_punch_in_out', () async {
    //given
    await _loadAdjustedStatusAndResetAllMocks();
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
    when(() => attendanceAdjustmentSubmitter.submitAdjustment(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.submitAdjustment('some work');

    //then
    verifyInOrder([
      () => view.clearError(),
      () => attendanceAdjustmentSubmitter.isLoading,
      () => view.showLoader(),
      () => selectedEmployeeProvider.getSelectedEmployeeForCurrentUser(),
      () => attendanceAdjustmentSubmitter.submitAdjustment(any()),
      () => view.hideLoader(),
      () =>
          view.onAdjustAttendanceFailed("Attendance adjustment failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('attendance_punch_in_out adjustment submission successful', () async {
    //given
    await _loadAdjustedStatusAndResetAllMocks();
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
    when(() => attendanceAdjustmentSubmitter.submitAdjustment(any())).thenAnswer((_) => Future.value(null));

    //when
    await presenter.submitAdjustment('some work');

    //then
    verifyInOrder([
      () => view.clearError(),
      () => attendanceAdjustmentSubmitter.isLoading,
      () => view.showLoader(),
      () => selectedEmployeeProvider.getSelectedEmployeeForCurrentUser(),
      () => attendanceAdjustmentSubmitter.submitAdjustment(any()),
      () => view.hideLoader(),
      () => view.onAdjustAttendanceSuccess('success', 'Adjustment submitted successfully'),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // MARK: Test for getters

  test('getting time period', () {
    TimeOfDay time1 = TimeOfDay(hour: 9, minute: 30);
    TimeOfDay time2 = TimeOfDay(hour: 15, minute: 30);

    expect(presenter.getPeriod(time1), 'AM');
    expect(presenter.getPeriod(time2), 'PM');
  });

  test('getting adjusted status', () {
    when(() => adjustedStatusProvider.getAdjustedStatus(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException));
    expect(presenter.getAdjustedStatus(), null);

    // when(() => adjustedStatusProvider.getAdjustedStatus(any()))
    //     .thenAnswer((_) => Future.value(AttendanceStatus.Present));
    // expect(presenter.getAdjustedStatus(), 'Present');
  });

  test('get status color', () {
    expect(presenter.getStatusColor(AttendanceStatus.Present), AppColors.presentColor);
    expect(presenter.getStatusColor(AttendanceStatus.Late), AppColors.lateColor);
    expect(presenter.getStatusColor(AttendanceStatus.Absent), AppColors.absentColor);
  });



}
