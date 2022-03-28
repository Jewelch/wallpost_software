import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_list_view.dart';

class MockAttendanceListView extends Mock implements AttendanceListView {}

class MockAttendanceListProvider extends Mock implements AttendanceListProvider {}

class MockAttendanceListItem extends Mock implements AttendanceListItem {}

void main() {
  var view = MockAttendanceListView();
  var mockAttendanceListProvider = MockAttendanceListProvider();
  late AttendanceListPresenter presenter;
  var month = DateTime.now().month;
  var year = DateTime.now().year;

  var attendanceListItem1 = MockAttendanceListItem();
  var attendanceListItem2 = MockAttendanceListItem();
  var attendanceListItem3 = MockAttendanceListItem();
  List<AttendanceListItem> _attendanceList = [attendanceListItem1, attendanceListItem2];

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockAttendanceListProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockAttendanceListProvider);
  }

  setUp(() {
    presenter = AttendanceListPresenter.initWith(view, mockAttendanceListProvider);
    _resetAllMockInteractions();
  });

  test('selected month and year is initialized successfully', () async {
    presenter = AttendanceListPresenter.initWith(view, mockAttendanceListProvider);

    expect(presenter.getSelectedMonth(), AppYears.shortenedMonthNames(year)[DateTime.now().month - 1]);
    expect(presenter.getSelectedYear(), AppYears.years().first);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //MARK: Test for loading list

  test('retrieving attendance_punch_in_out list successfully', () async {
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year)).thenAnswer((_) => Future.value(_attendanceList));

    await presenter.loadAttendanceList();

    verifyInOrder([
      () => mockAttendanceListProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceListProvider.get(month, year),
      () => view.showAttendanceList(_attendanceList),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving attendance_punch_in_out list successfully with empty list', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year)).thenAnswer((_) => Future.value(List.empty()));

    //when
    await presenter.loadAttendanceList();

    //then
    verifyInOrder([
      () => mockAttendanceListProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceListProvider.get(month, year),
      () => view.showNoListMessage(
          "There is no attendance_punch_in_out for ${presenter.getSelectedMonth()} ${presenter.getSelectedYear()}.\n\nTap here to reload."),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving attendance_punch_in_out list failure', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year)).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadAttendanceList();

    //then
    verifyInOrder([
      () => mockAttendanceListProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceListProvider.get(month, year),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      () => view.hideLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('refresh the attendance_punch_in_out list', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year)).thenAnswer((_) => Future.value(_attendanceList));

    await presenter.loadAttendanceList();
    _resetAllMockInteractions();

    //when
    await presenter.refresh();

    //then
    verifyInOrder([
      () => mockAttendanceListProvider.reset(),
      () => mockAttendanceListProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceListProvider.get(month, year),
      () => view.showAttendanceList(_attendanceList),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('selecting month and year', () {
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(any(), any())).thenAnswer((_) => Future.value(_attendanceList));
    var year = 2020;
    String month = 'Jan';

    presenter.selectYear(year);
    presenter.selectMonth(month);

    expect(presenter.getSelectedYear(), year);
    expect(presenter.getSelectedMonth(), month);
  });

  //MARK: Test for getters.

  test('get status color', () {
    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Present);
    when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Absent);

    expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.presentColor);
    expect(presenter.getStatusColorForItem(attendanceListItem2), AppColors.absentColor);
  });

  test('get punchIn label color', () {
    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Late);
    when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Present);

    expect(presenter.getPunchInLabelColorForItem(attendanceListItem1), AppColors.lateColor);
    expect(presenter.getPunchInLabelColorForItem(attendanceListItem2), Colors.black);
  });

  test('get punchOut label color', () {
    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.HalfDay);
    when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Absent);
    when(() => attendanceListItem3.status).thenReturn(AttendanceStatus.Present);

    expect(presenter.punchOutLabelColorForItem(attendanceListItem1), AppColors.lateColor);
    expect(presenter.punchOutLabelColorForItem(attendanceListItem2), AppColors.absentColor);
    expect(presenter.punchOutLabelColorForItem(attendanceListItem3), Colors.black);
  });
}
