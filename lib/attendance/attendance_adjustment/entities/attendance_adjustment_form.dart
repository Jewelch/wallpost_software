import 'package:flutter/material.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

import '../../attendance__core/entities/attendance_status.dart';

class AttendanceAdjustmentForm implements JSONConvertible {
  final String companyId;
  final String employeeId;
  final DateTime date;
  final String reason;
  final TimeOfDay? adjustedPunchInTime;
  final TimeOfDay? adjustedPunchOutTime;
  final AttendanceStatus adjustedStatus;

  AttendanceAdjustmentForm(
    this.companyId,
    this.employeeId,
    this.date,
    this.reason,
    this.adjustedPunchInTime,
    this.adjustedPunchOutTime,
    this.adjustedStatus,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'attendance_id': null,
      'date': date.yyyyMMddString(),
      'reason': reason,
      'adjusted_punchin': adjustedPunchInTime != null ? adjustedPunchInTime!.HHmmString() : null,
      'adjusted_punchout': adjustedPunchOutTime != null ? adjustedPunchOutTime!.HHmmString() : null,
      'adjusted_status': adjustedStatus.toRawString(),
      'employee_id': employeeId,
      'company_id': companyId,
    };
  }
}
