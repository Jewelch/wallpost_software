import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

const _PRESENT_STRING = "present";
const _LATE_STRING = "late";
const _ABSENT_STRING = "absent";
const _NO_ACTION_STRING = "noaction";
const _BREAK_STRING = "break";
const _HALF_DAY_STRING = "halfday";
const _EARLY_LEAVE_STRING = "earlyleave";

enum AttendanceStatus {
  Present,
  Late,
  Absent,
  NoAction,
  Break,
  HalfDay,
  EarlyLeave,
}

AttendanceStatus? initializeAttendanceStatusFromString(String string) {
  if (string.toLowerCase() == _PRESENT_STRING) {
    return AttendanceStatus.Present;
  } else if (string.toLowerCase() == _LATE_STRING) {
    return AttendanceStatus.Late;
  } else if (string.toLowerCase() == _ABSENT_STRING) {
    return AttendanceStatus.Absent;
  } else if (string.toLowerCase() == _NO_ACTION_STRING) {
    return AttendanceStatus.NoAction;
  } else if (string.toLowerCase() == _BREAK_STRING) {
    return AttendanceStatus.Break;
  } else if (string.toLowerCase() == _HALF_DAY_STRING) {
    return AttendanceStatus.HalfDay;
  } else if (string.toLowerCase() == _EARLY_LEAVE_STRING) {
    return AttendanceStatus.EarlyLeave;
  }
  return null;
}

extension AttendanceStatusExtension on AttendanceStatus {
  String toRawString() {
    switch (this) {
      case AttendanceStatus.Present:
        return _PRESENT_STRING;
      case AttendanceStatus.Late:
        return _LATE_STRING;
      case AttendanceStatus.Absent:
        return _ABSENT_STRING;
      case AttendanceStatus.NoAction:
        return _NO_ACTION_STRING;
      case AttendanceStatus.Break:
        return _BREAK_STRING;
      case AttendanceStatus.HalfDay:
        return _HALF_DAY_STRING;
      case AttendanceStatus.EarlyLeave:
        return _EARLY_LEAVE_STRING;
    }
  }

  String toReadableString() {
    switch (this) {
      case AttendanceStatus.Present:
        return "Present";
      case AttendanceStatus.Late:
        return "Late";
      case AttendanceStatus.Absent:
        return "Absent";
      case AttendanceStatus.NoAction:
        return "No Action";
      case AttendanceStatus.Break:
        return "Break";
      case AttendanceStatus.HalfDay:
        return "Half Day";
      case AttendanceStatus.EarlyLeave:
        return "Early Leave";
    }
  }

  Color statusColor() {
    switch (this) {
      case AttendanceStatus.Present:
      case AttendanceStatus.NoAction:
      case AttendanceStatus.Break:
        return AppColors.presentColor;
      case AttendanceStatus.Late:
      case AttendanceStatus.HalfDay:
      case AttendanceStatus.EarlyLeave:
        return AppColors.lateColor;
      case AttendanceStatus.Absent:
        return AppColors.absentColor;
    }
  }

  Color punchInLabelColor() {
    switch (this) {
      case AttendanceStatus.Late:
        return AppColors.lateColor;
      default:
        return Colors.black;
    }
  }

  Color punchOutLabelColor() {
    switch (this) {
      case AttendanceStatus.HalfDay:
        return AppColors.lateColor;
      case AttendanceStatus.Absent:
        return AppColors.absentColor;
      default:
        return Colors.black;
    }
  }
}
