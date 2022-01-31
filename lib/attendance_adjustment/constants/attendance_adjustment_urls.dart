import 'package:wallpost/_shared/constants/base_urls.dart';

class AttendanceAdjustmentUrls {
  static String getAttendanceListsUrl(
      String companyId, String employeeId, int month, int year) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance-adjustment?scope=my&perPage=50&employee_id=$employeeId&month=$month&year=$year';
  }

  static String getAdjustedStatusUrl(String companyId, String employeeId,
      String date, String punchInTime, String punchOutTime) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance-adjustment/work_status?date=$date&adjusted_punchin=$punchInTime&adjusted_punchout=$punchOutTime';
  }

  static String submitAdjustmentUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance-adjustment';
  }
}
