import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/attendance_report_provider.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_reports_view.dart';

class AttendanceReportPresenter {
  final AttendanceReportsView reportsView;
  final AttendanceReportProvider _attendanceReportProvider;

  AttendanceReportPresenter({required this.reportsView}) : _attendanceReportProvider = AttendanceReportProvider();

  AttendanceReportPresenter.initWith(
    this.reportsView,
    this._attendanceReportProvider,
  );

  //MARK: Function to load attendance report

  Future<void> loadAttendanceReport() async {
    try {
      reportsView.showLoader();
      var attendanceReport = await _attendanceReportProvider.getReport();
      reportsView.showAttendanceReport(attendanceReport);
    } on WPException {
      reportsView.showErrorAndRetryView("Failed to load report.\nTap to reload");
    }
  }
}
