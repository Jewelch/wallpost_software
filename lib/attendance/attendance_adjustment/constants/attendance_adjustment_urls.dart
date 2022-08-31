import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

class AttendanceAdjustmentUrls {
  static String getAttendanceListsUrl(String companyId, String employeeId, int month, int year) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance-adjustment?scope=my&perPage=50&employee_id=$employeeId&month=$month&year=$year';
  }

  static String getAdjustedStatusUrl(
    String companyId,
    String employeeId,
    DateTime date,
    TimeOfDay? adjustedPunchInTime,
    TimeOfDay? adjustedPunchOutTime,
  ) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance-adjustment/work_status?';
    url += 'date=${date.yyyyMMddString()}';

    if (adjustedPunchInTime == null)
      url += '&adjusted_punchin=null';
    else
      url += '&adjusted_punchin=${adjustedPunchInTime.HHmmString()}';

    if (adjustedPunchOutTime == null)
      url += '&adjusted_punchout=null';
    else
      url += '&adjusted_punchout=${adjustedPunchOutTime.HHmmString()}';

    return url;
  }

  static String submitAdjustmentUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/attendance-adjustment/single';
  }
}
