import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/contracts/attendance_list_view.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';

class MockAttendanceListView extends Mock implements AttendanceListView {}

class MockAttendanceListProvider extends Mock
    implements AttendanceListProvider {}

class MockAttendanceListItem extends Mock implements AttendanceListItem {}

void main() {
  var view = MockAttendanceListView();
  var mockAttendanceListProvider = MockAttendanceListProvider();
  late AttendanceListPresenter presenter;
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  var selectedMonth = DateFormat.MMM().format(DateTime.now());

  var attendanceListItem1 = MockAttendanceListItem();
  var attendanceListItem2 = MockAttendanceListItem();
  var attendanceListItem3 = MockAttendanceListItem();
  List<AttendanceListItem> _attendanceList = [
    attendanceListItem1,
    attendanceListItem2
  ];

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockAttendanceListProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockAttendanceListProvider);
  }

  setUp(() {
    presenter =
        AttendanceListPresenter.initWith(view, mockAttendanceListProvider);
    _resetAllMockInteractions();
  });

  test('selected month and year initialized successfully', () async {
    presenter = AttendanceListPresenter.initWith(view, mockAttendanceListProvider);

    expect(presenter.getSelectedMonth(),'Feb');
    expect(presenter.getSelectedYear(),2022);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving attendance list successfully', () async {
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year))
        .thenAnswer((_) => Future.value(_attendanceList));

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

  test('retrieving companies successfully with empty list', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year))
        .thenAnswer((_) => Future.value(List.empty()));

    //when
    await presenter.loadAttendanceList();

    //then
    verifyInOrder([
      () => mockAttendanceListProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceListProvider.get(month, year),
      () => view.showNoListMessage("There is no attendance for ${presenter.getSelectedMonth()} ${presenter.getSelectedYear()}.\n\nTap here to reload."),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving attendance list failed', () async {
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
      () => view.showErrorMessage(
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      () => view.hideLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('refresh the attendance list ', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month, year))
        .thenAnswer((_) => Future.value(_attendanceList));

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

  test('selecting month and year successful', () {
    presenter.selectYear(year);
    presenter.selectMonth(selectedMonth);

    expect(presenter.getSelectedYear(), year);
    expect(presenter.getSelectedMonth(), selectedMonth);

  });

  test('test for get status color', () {
    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Present);
    when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Absent);

    expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.presentColor);
    expect(presenter.getStatusColorForItem(attendanceListItem2), AppColors.absentColor);

  });

  test('test for get punchIn label color', () {
    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Late);
    when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Present);

    expect(presenter.getPunchInLabelColorForItem(attendanceListItem1), AppColors.lateColor);
    expect(presenter.getPunchInLabelColorForItem(attendanceListItem2), Colors.black);

  });

  test('test for get punchOut label color', () {
    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.HalfDay);
    when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Absent);
    when(() => attendanceListItem3.status).thenReturn(AttendanceStatus.Present);

    expect(presenter.punchOutLabelColorForItem(attendanceListItem1), AppColors.lateColor);
    expect(presenter.punchOutLabelColorForItem(attendanceListItem2), AppColors.absentColor);
    expect(presenter.punchOutLabelColorForItem(attendanceListItem3), Colors.black);

  });
}
