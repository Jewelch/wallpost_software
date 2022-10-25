import 'package:wallpost/_shared/constants/base_urls.dart';

class AttendanceUrls {
  static String getAttendanceDetailsUrl() {
    return '${BaseUrls.hrUrlV2()}/widget/attendance/is_allowed';
  }

  static String attendanceReportUrl(String startDate, String endDate) {
    return '${BaseUrls.hrUrlV2()}/widget/attendance/reportsCountHR?'
        '&scope=MY&date_from=$startDate&date_to=$endDate';
  }

  static String punchInUrl(bool isLocationValid) {
    var url = '${BaseUrls.hrUrlV2()}/widget/attendance/punch_in';
    if (isLocationValid == false) url += '?punchin_invalid_location=Y';
    return url;
  }

  static String punchOutUrl(String attendanceId, bool isLocationValid) {
    var url = '${BaseUrls.hrUrlV2()}/widget/attendance/$attendanceId/punch_out';
    if (isLocationValid == false) url += '?punchout_invalid_location=Y';
    return url;
  }

  static String breakStartUrl(String attendanceDetailsId) {
    return "${BaseUrls.hrUrlV2()}/widget/attendance/$attendanceDetailsId/break_in";
  }

  static String breakEndUrl(String attendanceDetailsId, String intervalId) {
    return "${BaseUrls.hrUrlV2()}/widget/attendance/$attendanceDetailsId/break_out/$intervalId";
  }
}
