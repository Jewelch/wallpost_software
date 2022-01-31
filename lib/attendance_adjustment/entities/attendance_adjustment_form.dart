import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class AttendanceAdjustmentForm implements JSONConvertible {
  final String date;
  final String reason;
  final String? adjustedPunchInTime;
  final String? adjustedPunchOutTime;

  AttendanceAdjustmentForm(
      this.date,
      this.reason,
      this.adjustedPunchInTime,
      this.adjustedPunchOutTime);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'reason': reason,
      'adjusted_punchin': adjustedPunchInTime,
      'adjusted_punchout': adjustedPunchOutTime,
    };
  }
}
