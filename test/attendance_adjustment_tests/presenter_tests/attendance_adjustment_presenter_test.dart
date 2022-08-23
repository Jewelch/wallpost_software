import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_adjustment_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_network_adapter.dart';
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
  var companyProvider = MockCompanyProvider();
  late AttendanceAdjustmentPresenter presenter;

  var _attendanceDate = DateTime(2022, 08, 20);
  var _originalPunchInTime = DateTime(2022, 08, 20, 9, 0);
  var _originalPunchOutTime = DateTime(2022, 08, 20, 18, 0);

  void _resetAllMocks() {
    reset(view);
    reset(companyProvider);
    reset(adjustedStatusProvider);
    reset(attendanceAdjustmentSubmitter);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(companyProvider);
    verifyNoMoreInteractions(adjustedStatusProvider);
    verifyNoMoreInteractions(attendanceAdjustmentSubmitter);
  }

  void _initPresenter() {
    presenter = AttendanceAdjustmentPresenter.initWith(
      view,
      attendanceListItem,
      adjustedStatusProvider,
      attendanceAdjustmentSubmitter,
      companyProvider,
    );
  }

  setUpAll(() {
    registerFallbackValue(MockAdjustedStatusForm());
    registerFallbackValue(MockAttendanceAdjustmentForm());
  });

  setUp(() {
    _resetAllMocks();
    when(() => attendanceListItem.status).thenReturn(AttendanceStatus.Present);
    when(() => attendanceListItem.date).thenReturn(_attendanceDate);
    when(() => attendanceListItem.punchInTime).thenReturn(_originalPunchInTime);
    when(() => attendanceListItem.punchOutTime).thenReturn(_originalPunchOutTime);

    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => company.employee).thenReturn(MockEmployee());
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
    _initPresenter();
  });

  test('test initialization when there is no punch in and out time', () async {
    //given
    when(() => attendanceListItem.status).thenReturn(AttendanceStatus.Absent);
    when(() => attendanceListItem.punchInTime).thenReturn(null);
    when(() => attendanceListItem.punchOutTime).thenReturn(null);
    _initPresenter();

    //then
    expect(presenter.getPunchInTimeString(), "No Punch In");
    expect(presenter.getPunchOutTimeString(), "No Punch Out");
    expect(presenter.getAdjustedPunchInTimeString(), "");
    expect(presenter.getAdjustedPunchOutTimeString(), "");
    expect(presenter.getAdjustedStatus(), "Absent");
  });

  test('test initialization when there is punch in and out time', () async {
    //given
    when(() => attendanceListItem.status).thenReturn(AttendanceStatus.Present);
    when(() => attendanceListItem.punchInTime).thenReturn(DateTime(2022, 08, 20, 9, 0));
    when(() => attendanceListItem.punchOutTime).thenReturn(DateTime(2022, 08, 20, 18, 0));
    _initPresenter();

    //then
    expect(presenter.getPunchInTimeString(), "09:00 AM");
    expect(presenter.getPunchOutTimeString(), "06:00 PM");
    expect(presenter.getAdjustedPunchInTimeString(), "09:00 AM");
    expect(presenter.getAdjustedPunchOutTimeString(), "06:00 PM");
    expect(presenter.getAdjustedStatus(), "Present");
  });

  group('tests for loading adjusted status', () {
    test('loading adjusted status when the service is running does nothing', () async {
      //given
      when(() => adjustedStatusProvider.isLoading).thenReturn(true);

      //when
      await presenter.loadAdjustedStatus();

      //then
      verifyInOrder([
        () => adjustedStatusProvider.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('failure to load adjusted status resets the adjusted time back to the previously selected time', () async {
      //given
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      var newPunchInTime = TimeOfDay(hour: 9, minute: 30);
      var newPunchOutTime = TimeOfDay(hour: 17, minute: 0);
      await presenter.loadAdjustedStatus(adjustedPunchInTime: newPunchInTime, adjustedPunchOutTime: newPunchOutTime);

      //then
      verifyInOrder([
        () => adjustedStatusProvider.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.updateAdjustedPunchInAndOutTime(),
        () => view.showAdjustedStatusLoader(),
        () => adjustedStatusProvider.getAdjustedStatus(any()),
        () => view.updateAdjustedPunchInAndOutTime(),
        () => view.onDidFailToLoadAdjustedStatus(
            "Failed to load adjusted status", InvalidResponseException().userReadableMessage),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('loading adjusted status successfully', () async {
      //given
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.HalfDay));

      //when
      var newPunchInTime = TimeOfDay(hour: 9, minute: 30);
      var newPunchOutTime = TimeOfDay(hour: 17, minute: 0);
      await presenter.loadAdjustedStatus(adjustedPunchInTime: newPunchInTime, adjustedPunchOutTime: newPunchOutTime);

      //then
      verifyInOrder([
        () => adjustedStatusProvider.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.updateAdjustedPunchInAndOutTime(),
        () => view.showAdjustedStatusLoader(),
        () => adjustedStatusProvider.getAdjustedStatus(any()),
        () => view.onDidLoadAdjustedStatus(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adjusted status form is built correctly', () async {
      //given
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.HalfDay));

      //when
      var newPunchInTime = TimeOfDay(hour: 9, minute: 30);
      var newPunchOutTime = TimeOfDay(hour: 17, minute: 0);
      await presenter.loadAdjustedStatus(adjustedPunchInTime: newPunchInTime, adjustedPunchOutTime: newPunchOutTime);

      //then
      var verificationResult = verify(() => adjustedStatusProvider.getAdjustedStatus(captureAny()));
      var adjustedStatusForm = verificationResult.captured.single as AdjustedStatusForm;
      expect(adjustedStatusForm.date, _attendanceDate);
      expect(adjustedStatusForm.adjustedPunchInTime, newPunchInTime);
      expect(adjustedStatusForm.adjustedPunchOutTime, newPunchOutTime);
    });
  });

  group('tests for submitting attendance adjustment', () {
    test('submitting adjustment when the service is loading does nothing', () async {
      //given
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(true);

      //when
      await presenter.submitAdjustment("some reason");

      //then
      verifyInOrder([
        () => attendanceAdjustmentSubmitter.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('validating adjusted punch in time', () async {
      //given
      when(() => attendanceListItem.punchInTime).thenReturn(null);
      when(() => attendanceListItem.punchOutTime).thenReturn(null);
      _initPresenter();
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);

      //when
      await presenter.submitAdjustment("some reason");

      //then
      expect(presenter.getAdjustedTimeError(), "Please select adjusted punch in time");
      expect(presenter.getReasonError(), null);
      verifyInOrder([
        () => attendanceAdjustmentSubmitter.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.clearReasonInputError(),
        () => view.notifyNoAdjustmentMade(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('validating adjusted punch out time', () async {
      //given
      when(() => attendanceListItem.punchInTime).thenReturn(DateTime.now());
      when(() => attendanceListItem.punchOutTime).thenReturn(null);
      _initPresenter();
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);

      //when
      await presenter.submitAdjustment("some reason");

      //then
      expect(presenter.getAdjustedTimeError(), "Please select adjusted punch out time");
      expect(presenter.getReasonError(), null);
      verifyInOrder([
        () => attendanceAdjustmentSubmitter.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.clearReasonInputError(),
        () => view.notifyNoAdjustmentMade(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('validating reason', () async {
      //given
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);

      //when
      await presenter.submitAdjustment("");

      //then
      expect(presenter.getAdjustedTimeError(), null);
      expect(presenter.getReasonError(), "Please enter a reason");
      verifyInOrder([
        () => attendanceAdjustmentSubmitter.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.clearReasonInputError(),
        () => view.notifyInvalidReason(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('failure to submit adjustment', () async {
      //given
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
      when(() => attendanceAdjustmentSubmitter.submitAdjustment(any()))
          .thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.submitAdjustment("some reason");

      //then
      verifyInOrder([
        () => attendanceAdjustmentSubmitter.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.clearReasonInputError(),
        () => companyProvider.getSelectedCompanyForCurrentUser(),
        () => view.showFormSubmissionLoader(),
        () => attendanceAdjustmentSubmitter.submitAdjustment(any()),
        () => view.onDidFailToAdjustAttendance("Adjustment Failed", InvalidResponseException().userReadableMessage),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('submitting adjustment successfully', () async {
      //given
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
      when(() => attendanceAdjustmentSubmitter.submitAdjustment(any())).thenAnswer((_) => Future.value(null));

      //when
      await presenter.submitAdjustment("some reason");

      //then
      verifyInOrder([
        () => attendanceAdjustmentSubmitter.isLoading,
        () => view.clearAdjustedTimeInputError(),
        () => view.clearReasonInputError(),
        () => companyProvider.getSelectedCompanyForCurrentUser(),
        () => view.showFormSubmissionLoader(),
        () => attendanceAdjustmentSubmitter.submitAdjustment(any()),
        () => view.onDidAdjustAttendanceSuccessfully(
            "Adjustment Successful", "Attendance has been adjusted successfully."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adjustment form is built correctly', () async {
      //given
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.Present));
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
      when(() => attendanceAdjustmentSubmitter.submitAdjustment(any())).thenAnswer((_) => Future.value(null));
      await presenter.loadAdjustedStatus(
        adjustedPunchInTime: TimeOfDay(hour: 9, minute: 15),
        adjustedPunchOutTime: TimeOfDay(hour: 17, minute: 45),
      );
      //when
      await presenter.submitAdjustment("some reason");

      //then
      var verificationResult = verify(() => attendanceAdjustmentSubmitter.submitAdjustment(captureAny()));
      var form = verificationResult.captured.single as AttendanceAdjustmentForm;

      expect(form.companyId, "someCompanyId");
      expect(form.date, _attendanceDate);
      expect(form.reason, "some reason");
      expect(form.adjustedPunchInTime, TimeOfDay(hour: 9, minute: 15));
      expect(form.adjustedPunchOutTime, TimeOfDay(hour: 17, minute: 45));
    });
  });

  group('getters tests', () {
    test('getting shouldDisableFormEntry', () {
      when(() => attendanceListItem.isApprovalPending()).thenReturn(true);
      expect(presenter.shouldDisableFormEntry(), true);

      when(() => attendanceListItem.isApprovalPending()).thenReturn(false);
      when(() => adjustedStatusProvider.isLoading).thenReturn(true);
      expect(presenter.shouldDisableFormEntry(), true);

      when(() => attendanceListItem.isApprovalPending()).thenReturn(false);
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(true);
      expect(presenter.shouldDisableFormEntry(), true);

      when(() => attendanceListItem.isApprovalPending()).thenReturn(false);
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(false);
      expect(presenter.shouldDisableFormEntry(), false);
    });

    test('getting attendance date', () {
      var company = MockCompany();
      when(() => company.dateFormat).thenReturn("dd-MM-yyyy");
      when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

      expect(presenter.getAttendanceDate(), "20-08-2022");
    });

    test('getting adjusted status', () {
      expect(presenter.getAdjustedStatus(), "Present");
    });

    test('status colors', () async {
      when(() => adjustedStatusProvider.isLoading).thenReturn(false);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.Present));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.green);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.NoAction));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.green);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.OnTime));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.green);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.Break));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.green);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.Late));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.yellow);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.HalfDay));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.yellow);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.EarlyLeave));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.yellow);

      when(() => adjustedStatusProvider.getAdjustedStatus(any()))
          .thenAnswer((_) => Future.value(AttendanceStatus.Absent));
      await presenter.loadAdjustedStatus(adjustedPunchInTime: TimeOfDay.now(), adjustedPunchOutTime: TimeOfDay.now());
      expect(presenter.getAdjustedStatusColor(), AppColors.red);
    });

    test('getting approval info', () {
      when(() => attendanceListItem.isApprovalPending()).thenReturn(false);
      when(() => attendanceListItem.approverName).thenReturn("Some Approver");
      expect(presenter.getApprovalInfo(), "");

      when(() => attendanceListItem.isApprovalPending()).thenReturn(true);
      when(() => attendanceListItem.approverName).thenReturn(null);
      expect(presenter.getApprovalInfo(), "");

      when(() => attendanceListItem.isApprovalPending()).thenReturn(true);
      when(() => attendanceListItem.approverName).thenReturn("Some Approver");
      expect(presenter.getApprovalInfo(), "Pending Approval with Some Approver");
    });

    test('getting adjusted times', () {
      when(() => attendanceListItem.status).thenReturn(AttendanceStatus.Absent);
      when(() => attendanceListItem.punchInTime).thenReturn(null);
      when(() => attendanceListItem.punchOutTime).thenReturn(null);
      _initPresenter();
      expect(presenter.adjustedPunchInTime, TimeOfDay(hour: 0, minute: 0));
      expect(presenter.adjustedPunchOutTime, TimeOfDay(hour: 0, minute: 0));

      when(() => attendanceListItem.status).thenReturn(AttendanceStatus.Absent);
      when(() => attendanceListItem.punchInTime).thenReturn(_originalPunchInTime);
      when(() => attendanceListItem.punchOutTime).thenReturn(_originalPunchOutTime);
      _initPresenter();
      expect(presenter.adjustedPunchInTime, TimeOfDay(hour: 9, minute: 0));
      expect(presenter.adjustedPunchOutTime, TimeOfDay(hour: 18, minute: 0));
    });

    test('getting adjustment reason', () {
      when(() => attendanceListItem.adjustmentReason).thenReturn("some reason");

      expect(presenter.getReason(), "some reason");
    });

    test('getting isLoadingAdjustedStatus', () {
      when(() => adjustedStatusProvider.isLoading).thenReturn(true);

      expect(presenter.isLoadingAdjustedStatus(), true);
    });

    test('getting isSubmittingAdjustment', () {
      when(() => attendanceAdjustmentSubmitter.isLoading).thenReturn(true);

      expect(presenter.isSubmittingAdjustment(), true);
    });
  });
}
