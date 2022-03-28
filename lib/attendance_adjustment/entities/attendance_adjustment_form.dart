import 'package:flutter/material.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/company_core/entities/employee.dart';

class AttendanceAdjustmentForm implements JSONConvertible {
  final Employee employee;
  final DateTime date;
  final String reason;
  final TimeOfDay? adjustedPunchInTime;
  final TimeOfDay? adjustedPunchOutTime;


  final AttendanceStatus adjustedStatus;

  AttendanceAdjustmentForm(
    this.employee,
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
      'employee_id': employee.v1Id,
      'company_id': employee.companyId,
    };
  }
}
