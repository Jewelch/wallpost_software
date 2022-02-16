import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_adjustment_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';

import '../../_mocks/mock_employee.dart';

class MockAttendanceAdjustmentView extends Mock
    implements AttendanceAdjustmentView {}

class MockAdjustedStatusProvider extends Mock
    implements AdjustedStatusProvider {}

class MockAttendanceAdjustmentSubmitter extends Mock
    implements AttendanceAdjustmentSubmitter {}

class MockAttendanceAdjustmentForm extends Mock
    implements AttendanceAdjustmentForm {}

class MockAdjustedStatusForm extends Mock implements AdjustedStatusForm {}

class MockSelectedEmployeeProvider extends Mock
    implements SelectedEmployeeProvider {}

void main() {
  var view = MockAttendanceAdjustmentView();
  var adjustedStatusProvider = MockAdjustedStatusProvider();
  var attendanceAdjustmentSubmitter = MockAttendanceAdjustmentSubmitter();
  var selectedEmployeeProvider = MockSelectedEmployeeProvider();
  var mockEmployee = MockEmployee();

  late AttendanceAdjustmentPresenter presenter;
  late AdjustedStatusForm adjustedStatusForm;
  late AttendanceAdjustmentForm attendanceAdjustmentForm;

  DateTime date = DateTime(22, 01, 2021);
  DateTime adjustedPunchInTime = DateFormat('hh:mm').parse("09:00");
  DateTime adjustedPunchOutTime = DateFormat('hh:mm').parse("06:00");
  String reason = 'some work';
  var adjustedStatus = AttendanceStatus.Present;

  adjustedStatusForm = AdjustedStatusForm(
    date,
    adjustedPunchInTime,
    adjustedPunchOutTime,
  );

  attendanceAdjustmentForm = AttendanceAdjustmentForm(
    mockEmployee,
    date,
    "some work",
    adjustedPunchInTime,
    adjustedPunchOutTime,
    adjustedStatus,
  );

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(adjustedStatusProvider);
    verifyNoMoreInteractions(attendanceAdjustmentSubmitter);
  }

  setUpAll(() {
    registerFallbackValue(MockAdjustedStatusForm());
    registerFallbackValue(MockAttendanceAdjustmentForm());
  });

  setUp(() {
    clearInteractions(view);
    clearInteractions(adjustedStatusProvider);
    clearInteractions(attendanceAdjustmentSubmitter);
  });

  test(
      'getting adjusted status when adjustedStatusProvider loading does nothing ',
      () async {
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(true);
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    await presenter.loadAdjustedStatus(date);

    //then
    verifyInOrder([
      () => adjustedStatusProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('get adjusted status successful', () async {
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(false);
    when(() => adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm))
        .thenAnswer((_) => Future.value(adjustedStatus));
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    await presenter.loadAdjustedStatus(date);

    //then
    verifyInOrder([
      () => adjustedStatusProvider.isLoading,
      () => view.showLoader(),
      () => adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm),
      () => view.hideLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failed to get adjusted status', () async {
    //given
    when(() => adjustedStatusProvider.isLoading).thenReturn(false);
    when(() => adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    await presenter.loadAdjustedStatus(date);

    //then
    verifyInOrder([
      () => adjustedStatusProvider.isLoading,
      () => view.showLoader(),
      () => adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm),
      () => view.hideLoader(),
      () => view.onGetAdjustedStatusFailed('Getting adjusted status failed',
          InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      'submitting adjusted attendance when attendanceAdjustmentSubmitter loading does nothing ',
      () async {
    //given
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(true);
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    presenter.adjustedStatus = AttendanceStatus.Present;
    await presenter.submitAdjustment(date, reason);

    //then
    verifyInOrder([
      () => view.clearError(),
      () => attendanceAdjustmentSubmitter.isLoading,
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('notifies view if reason is empty', () async {
    //given
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    await presenter.submitAdjustment(date, '');

    //then
    verifyInOrder([
      () => view.clearError(),
      () => view.notifyInvalidReason('Invalid reason'),
      () =>
          view.notifyInvalidAdjustedStatus("Failed", "Attendance not adjusted"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('attendance adjustment submission successful', () async {
    //given
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
    when(() => attendanceAdjustmentSubmitter.submitAdjustment(
        attendanceAdjustmentForm)).thenAnswer((_) => Future.value(null));
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    presenter.adjustedStatus = AttendanceStatus.Present;
    await presenter.submitAdjustment(date, reason);

    //then
    verifyInOrder([
      () => view.clearError(),
      () => attendanceAdjustmentSubmitter.isLoading,
      () => view.showLoader(),
      () => attendanceAdjustmentSubmitter
          .submitAdjustment(attendanceAdjustmentForm),
      () => view.hideLoader(),
      () => view.onAdjustAttendanceSuccess(
          'Done', 'Adjustment submitted successfully'),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failed to submit adjusted attendance', () async {
    //given
    when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
    when(() => attendanceAdjustmentSubmitter
            .submitAdjustment(attendanceAdjustmentForm))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);

    //when
    presenter.adjustedStatus = AttendanceStatus.Present;
    await presenter.submitAdjustment(date, reason);

    //then
    verifyInOrder([
      () => view.clearError(),
      () => attendanceAdjustmentSubmitter.isLoading,
      () => view.showLoader(),
      () => attendanceAdjustmentSubmitter
          .submitAdjustment(attendanceAdjustmentForm),
      () => view.hideLoader(),
      () => view.onAdjustAttendanceFailed("Attendance adjustment failed",
          InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting time period', () {
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);
    TimeOfDay time1 = TimeOfDay(hour: 9, minute: 30);
    TimeOfDay time2 = TimeOfDay(hour: 15, minute: 30);

    expect(presenter.getPeriod(time1), 'AM');
    expect(presenter.getPeriod(time2), 'PM');
  });

  test('change color of time picker after adjustment', () {
    presenter = AttendanceAdjustmentPresenter.initWith(
        view,
        attendanceAdjustmentSubmitter,
        adjustedStatusProvider,
        selectedEmployeeProvider);
    presenter.punchInTime = TimeOfDay(hour: 9, minute: 30);
    presenter.adjustedTime = TimeOfDay(hour: 10, minute: 30);
    presenter.punchOutTime = TimeOfDay(hour: 11, minute: 30);

    presenter.changePropertiesOfPunchInContainer();
    presenter.changePropertiesOfPunchOutContainer();

    expect(presenter.adjustedPunchInColor, AppColors.lightBlueColor);
    expect(presenter.adjustedPunchOutColor, AppColors.lightBlueColor);
  });
}
