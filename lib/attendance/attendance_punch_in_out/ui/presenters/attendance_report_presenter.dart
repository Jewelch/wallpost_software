import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/attendance_report_provider.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_detailed_view.dart';

class AttendanceReportPresenter {
  final AttendanceDetailedView detailedView;
  final AttendanceReportProvider _attendanceReportProvider;

  AttendanceReportPresenter({required this.detailedView}) : _attendanceReportProvider = AttendanceReportProvider();

  AttendanceReportPresenter.initWith(
    this.detailedView,
    this._attendanceReportProvider,
  );

  //MARK: Function to load attendance report

  Future<void> loadAttendanceReport() async {
    try {
      detailedView.showAttendanceReportLoader();
      var attendanceReport = await _attendanceReportProvider.getReport();
      detailedView.showAttendanceReport(attendanceReport);
    } on WPException {
      detailedView.showAttendanceReportErrorAndRetryView("Failed to load report.\nTap to reload");
    }
  }
}
