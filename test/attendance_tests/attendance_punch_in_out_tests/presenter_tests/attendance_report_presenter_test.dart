import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_report.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/attendance_report_provider.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/presenters/attendance_report_presenter.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_report_view.dart';

class MockAttendanceReportView extends Mock implements AttendanceReportView {}

class MockAttendanceReportProvider extends Mock implements AttendanceReportProvider {}

class MockAttendanceReport extends Mock implements AttendanceReport {}

main() {
  var view = MockAttendanceReportView();
  var attendanceReportProvider = MockAttendanceReportProvider();
  late AttendanceReportPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(attendanceReportProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(attendanceReportProvider);
  }

  setUpAll(() {
    registerFallbackValue(MockAttendanceReport());
  });

  setUp(() {
    _clearAllInteractions();
    presenter = AttendanceReportPresenter.initWith(view, attendanceReportProvider);
  });

  //MARK: Tests for loading the list

  test('does nothing when the provider is loading', () async {
    //given
    when(() => attendanceReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadAttendanceReport();

    //then
    verifyInOrder([
      () => attendanceReportProvider.isLoading,
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to load report', () async {
    //given
    when(() => attendanceReportProvider.isLoading).thenReturn(false);
    when(() => attendanceReportProvider.getReport()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadAttendanceReport();

    //then
    verifyInOrder([
      () => attendanceReportProvider.isLoading,
      () => view.showLoader(),
      () => attendanceReportProvider.getReport(),
      () => view.showErrorAndRetryView("Failed to load attendance report.\nTap to reload"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the report ', () async {
    //given
    var attendanceReport = MockAttendanceReport();
    when(() => attendanceReportProvider.isLoading).thenReturn(false);
    when(() => attendanceReportProvider.getReport()).thenAnswer((_) => Future.value(attendanceReport));

    //when
    await presenter.loadAttendanceReport();

    //then
    verifyInOrder([
      () => attendanceReportProvider.isLoading,
      () => view.showLoader(),
      () => attendanceReportProvider.getReport(),
      () => view.showAttendanceReport(any()),
    ]);
    _verifyNoMoreInteractions();
  });
}
