import 'package:flutter/material.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class AdjustedStatusForm implements JSONConvertible {
  final DateTime date;
  final TimeOfDay? adjustedPunchInTime;
  final TimeOfDay? adjustedPunchOutTime;

  AdjustedStatusForm(
    this.date,
    this.adjustedPunchInTime,
    this.adjustedPunchOutTime,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.yyyyMMddString(),
      'adjusted_punchin': adjustedPunchInTime != null ? adjustedPunchInTime!.HHmmString() : null,
      'adjusted_punchout': adjustedPunchOutTime != null ? adjustedPunchOutTime!.HHmmString() : null,
    };
  }
}
