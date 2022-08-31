import 'dart:ui';

import '../../../_shared/constants/app_colors.dart';
import '../entities/attendance_status.dart';

class AttendanceStatusColor {
  static Color getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.Present:
      case AttendanceStatus.NoAction:
      case AttendanceStatus.OnTime:
      case AttendanceStatus.Break:
        return AppColors.green;
      case AttendanceStatus.Late:
      case AttendanceStatus.HalfDay:
      case AttendanceStatus.EarlyLeave:
        return AppColors.yellow;
      case AttendanceStatus.Absent:
        return AppColors.red;
    }
  }
}
