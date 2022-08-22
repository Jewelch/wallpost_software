import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_list_view.dart';

class MockAttendanceListView extends Mock implements AttendanceListView {}

class MockAttendanceListProvider extends Mock implements AttendanceListProvider {}

class MockAttendanceListItem extends Mock implements AttendanceListItem {}

class MockAppYears extends Mock implements AppYears {}

void main() {
  var view = MockAttendanceListView();
  var mockAttendanceListProvider = MockAttendanceListProvider();
  var yearsAndMonthsProvider = MockAppYears();
  late AttendanceListPresenter presenter;

  var attendanceListItem1 = MockAttendanceListItem();
  var attendanceListItem2 = MockAttendanceListItem();
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
    when(() => yearsAndMonthsProvider.years()).thenReturn([2021, 2022]);
    when(() => yearsAndMonthsProvider.currentAndPastMonthsOfTheCurrentYear(2022)).thenReturn(["Jan", "Feb"]);
    when(() => yearsAndMonthsProvider.currentAndPastMonthsOfTheCurrentYear(2021)).thenReturn(["Jan", "Feb", "Mar"]);
    presenter = AttendanceListPresenter.initWith(view, mockAttendanceListProvider, yearsAndMonthsProvider);
    _resetAllMockInteractions();
  });

  test('selected month and year is initialized in constructor', () async {
    presenter = AttendanceListPresenter.initWith(view, mockAttendanceListProvider, yearsAndMonthsProvider);

    expect(presenter.getSelectedYear(), "2022");
    expect(presenter.getSelectedMonth(), "Feb");
    _verifyNoMoreInteractionsOnAllMocks();
  });

  group('tests for loading the data', () {
    test('loading attendance list when the service is loading does nothing', () async {
      //given
      when(() => mockAttendanceListProvider.isLoading).thenReturn(true);

      //when
      await presenter.loadAttendanceList();

      //then
      verifyInOrder([
        () => mockAttendanceListProvider.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('failure to load the attendance list', () async {
      //given
      when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceListProvider.get(any(), any()))
          .thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.loadAttendanceList();

      //then
      verifyInOrder([
        () => mockAttendanceListProvider.isLoading,
        () => view.showLoader(),
        () => mockAttendanceListProvider.get(any(), any()),
        () => view
            .onDidFailToLoadAttendanceList("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully loading an empty list', () async {
      //given
      when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceListProvider.get(any(), any())).thenAnswer((_) => Future.value([]));

      //when
      await presenter.loadAttendanceList();

      //then
      verifyInOrder([
        () => mockAttendanceListProvider.isLoading,
        () => view.showLoader(),
        () => mockAttendanceListProvider.get(any(), any()),
        () => view.showNoAttendanceMessage(
            "There is no attendance for ${presenter.getSelectedMonth()} ${presenter.getSelectedYear()}.\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully loading a list', () async {
      when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceListProvider.get(any(), any())).thenAnswer((_) => Future.value(_attendanceList));

      await presenter.loadAttendanceList();

      verifyInOrder([
        () => mockAttendanceListProvider.isLoading,
        () => view.showLoader(),
        () => mockAttendanceListProvider.get(any(), any()),
        () => view.onDidLoadAttendanceList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for getting list details', () {
    test('getting list item count and list items', () async {
      //given
      when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceListProvider.get(any(), any())).thenAnswer((_) => Future.value(_attendanceList));
      await presenter.loadAttendanceList();

      //then
      expect(presenter.getNumberOfListItems(), 2);
      expect(presenter.getItemAtIndex(0), attendanceListItem1);
      expect(presenter.getItemAtIndex(1), attendanceListItem2);
    });

    test('getting list item details', () async {
      //given
      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Present);
      when(() => attendanceListItem1.date).thenReturn(DateTime(2022, 8, 30));
      when(() => attendanceListItem1.punchInTime).thenReturn(DateTime(2022, 8, 30, 9, 0));
      when(() => attendanceListItem1.punchOutTime).thenReturn(DateTime(2022, 8, 30, 14, 30));

      //then
      expect(presenter.getListItemTitle(attendanceListItem1), "Tuesday, 09:00 AM to 02:30 PM");
      expect(presenter.getMonth(attendanceListItem1), "Aug");
      expect(presenter.getDay(attendanceListItem1), "30");
      expect(presenter.getStatus(attendanceListItem1), "Present");

      //given
      when(() => attendanceListItem2.status).thenReturn(AttendanceStatus.Absent);
      when(() => attendanceListItem2.date).thenReturn(DateTime(2022, 8, 30));

      //then
      expect(presenter.getListItemTitle(attendanceListItem2), "Tuesday");
      expect(presenter.getMonth(attendanceListItem2), "Aug");
      expect(presenter.getDay(attendanceListItem2), "30");
      expect(presenter.getStatus(attendanceListItem2), "Absent");
    });

    test('getting status color', () async {
      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Present);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.green);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.NoAction);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.green);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.OnTime);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.green);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Break);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.green);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Late);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.yellow);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.HalfDay);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.yellow);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.EarlyLeave);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.yellow);

      when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Absent);
      expect(presenter.getStatusColorForItem(attendanceListItem1), AppColors.red);
    });

    test('getting approval info when approval is not pending', () {
      var attendanceListItem = MockAttendanceListItem();
      when(() => attendanceListItem.isApprovalPending()).thenReturn(false);

      expect(presenter.getApprovalInfo(attendanceListItem), "");
    });

    test('getting approval info when approval is pending', () {
      var attendanceListItem = MockAttendanceListItem();
      when(() => attendanceListItem.isApprovalPending()).thenReturn(true);
      when(() => attendanceListItem.approverName).thenReturn("Some Approver Name");

      expect(presenter.getApprovalInfo(attendanceListItem), "Pending Approval with Some Approver Name");
    });
  });

  group('tests for filters', () {
    test('getting filter values', () {
      expect(presenter.getYearsList(), ["2021", "2022"]);
      expect(presenter.getMonthsListOfSelectedYear(), ["Jan", "Feb"]);
    });

    test('selecting year filter', () async {
      //given
      when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceListProvider.get(any(), any())).thenAnswer((_) => Future.value(_attendanceList));

      //when
      await presenter.selectYear(2021);

      //then
      expect(presenter.getSelectedYear(), "2021");
      verifyInOrder([
        () => mockAttendanceListProvider.isLoading,
        () => view.showLoader(),
        () => mockAttendanceListProvider.get(any(), any()),
        () => view.onDidLoadAttendanceList(),
      ]);
    });

    test('selecting month filter', () async {
      //given
      when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
      when(() => mockAttendanceListProvider.get(any(), any())).thenAnswer((_) => Future.value(_attendanceList));

      //when
      await presenter.selectMonth("Jan");

      //then
      expect(presenter.getSelectedMonth(), "Jan");
      verifyInOrder([
        () => mockAttendanceListProvider.isLoading,
        () => view.showLoader(),
        () => mockAttendanceListProvider.get(any(), any()),
        () => view.onDidLoadAttendanceList(),
      ]);
    });

    test('selecting year filter resets the month filter if month in not available in selected year', () async {
      //given
      presenter.selectYear(2021);
      presenter.selectMonth("Mar");

      //when
      await presenter.selectYear(2022);

      //then
      expect(presenter.getSelectedYear(), "2022");
      expect(presenter.getSelectedMonth(), "Feb");
    });
  });

/*








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
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.presentColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.NoAction);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.presentColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.OnTime);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.presentColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Break);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.presentColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Late);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.lateColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.HalfDay);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.lateColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.EarlyLeave);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.lateColor);

    when(() => attendanceListItem1.status).thenReturn(AttendanceStatus.Absent);
    expect(presenter.getStatusColorForItem(attendanceListItem1), presenter.absentColor);
  });

 */
}
