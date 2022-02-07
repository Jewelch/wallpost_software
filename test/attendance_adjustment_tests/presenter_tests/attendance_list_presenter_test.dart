import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/contracts/attendance_list_view.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';

class MockAttendanceListView extends Mock implements AttendanceListView {}

class MockAttendanceListProvider extends Mock implements AttendanceListProvider {}

class MockAttendanceListItem extends Mock implements AttendanceListItem {}

void main(){
  var view = MockAttendanceListView();
  var mockAttendanceListProvider = MockAttendanceListProvider();
  late AttendanceListPresenter presenter;
  var month = DateTime.now().month;
  var year = DateTime.now().year;


  var attendanceListItem1 = MockAttendanceListItem();
  var attendanceListItem2 = MockAttendanceListItem();
  List<AttendanceListItem> _attendanceList = [attendanceListItem1,attendanceListItem2];

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

  test('retrieving attendance list successfully', () async {
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month,year)).thenAnswer((_) =>  Future.value(_attendanceList));

    await presenter.loadAttendanceList(month,year);

    verifyInOrder([
          () => mockAttendanceListProvider.isLoading,
          () => view.showLoader(),
          () => mockAttendanceListProvider.get(month,year),
          () => view.showAttendanceList(_attendanceList),
          () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies successfully with empty list', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month,year)).thenAnswer((_) =>  Future.value(List.empty()));

    //when
    await presenter.loadAttendanceList(month,year);

    //then
    verifyInOrder([
          () => mockAttendanceListProvider.isLoading,
          () => view.showLoader(),
          () => mockAttendanceListProvider.get(month,year),
          () => view.showNoListMessage("There are no attendance list available.\n\nTap here to reload"),
          () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving attendance list failed', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month,year)).thenAnswer(
          (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadAttendanceList(month,year);

    //then
    verifyInOrder([
          () => mockAttendanceListProvider.isLoading,
          () => view.showLoader(),
          () => mockAttendanceListProvider.get(month,year),
          () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
          () => view.hideLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('refresh the attendance list ', () async {
    //given
    when(() => mockAttendanceListProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceListProvider.get(month,year)).thenAnswer((_) => Future.value(_attendanceList));

    await presenter.loadAttendanceList(month,year);
    _resetAllMockInteractions();

    //when
    await presenter.refresh();

    //then
    verifyInOrder([
          () => mockAttendanceListProvider.reset(),
          () => mockAttendanceListProvider.isLoading,
          () => view.showLoader(),
          () => mockAttendanceListProvider.get(month,year),
          () => view.showAttendanceList(_attendanceList),
          () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}