import 'package:wallpost/_shared/constants/base_urls.dart';

class AttendanceUrls {
  static String getAttendanceDetailsUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance';
  }

  static String punchInFromAppPermissionProviderUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/punchInAllowedFromApp?';
  }

  static String punchInNowPermissionProviderUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/inoutrules/is_allowed_punchin?';
  }

  static String attendanceLocationValidationUrl(String companyId, String employeeId, bool isPunchingIn) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/location/validate?';
    url += '&flow_type=${isPunchingIn ? 'IN' : 'OUT'}';
    return url;
  }

  static String punchInUrl(String companyId, String employeeId, bool isLocationValid) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance/punch_in';
    if (isLocationValid == false) url += '?punchin_invalid_location=Y';
    return url;
  }
}
