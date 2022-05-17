import 'package:wallpost/_shared/constants/base_urls.dart';

class AttendanceUrls {
  static String getAttendanceDetailsUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/widget/attendance/is_allowed';
  }
  static String attendanceReportUrl(String companyId, String employeeId, String startDate, String endDate) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/reportsCountHR?'
        '&scope=MY&date_from=$startDate&date_to=$endDate';
  }

  static String attendancePermissionsUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/widget/is_allowed_punchin';
  }

  static String attendanceLocationValidationUrl(String companyId, String employeeId, bool isPunchingIn) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/location/validate?';
    url += '&flow_type=${isPunchingIn ? 'IN' : 'OUT'}';
    return url;
  }

  static String punchInUrl(String companyId, String employeeId, bool isLocationValid) {
    var url = '${BaseUrls.hrUrlV2()}/widget/attendance/punch_in';
    if (isLocationValid == false) url += '?punchin_invalid_location=Y';
    return url;
  }

  static String punchOutUrl(String companyId, String employeeId, String attendanceId, bool isLocationValid) {
    var url = '${BaseUrls.hrUrlV2()}/widget/attendance/4xKmQeR32hn9fyb/punch_out';
    if (isLocationValid == false) url += '?punchout_invalid_location=Y';
    return url;
  }

  static String breakStartUrl(String companyId, String employeeId, String attendanceDetailsId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/$attendanceDetailsId/break_in';
  }

  static String breakEndUrl(String companyId, String employeeId, String attendanceDetailsId, String intervalId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/$attendanceDetailsId'
        '/break_out/$intervalId';
  }
}
