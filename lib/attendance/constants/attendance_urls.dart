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
}
