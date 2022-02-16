const _PRESENT_STRING = "present";
const _LATE_STRING = "late";
const _ABSENT_STRING = "absent";
const _NO_ACTION_STRING = "noaction";
const _BREAK_STRING = "break";
const _HALF_DAY_STRING = "halfday";
const _EARLY_LEAVE_STRING = "earlyleave";
const _ON_TIME_STRING = "ontime";

enum AttendanceStatus {
  Present,
  Late,
  Absent,
  NoAction,
  Break,
  HalfDay,
  EarlyLeave,
  OnTime
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
  } else if (string.toLowerCase() == _ON_TIME_STRING) {
    return AttendanceStatus.OnTime;
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
      case AttendanceStatus.OnTime:
        return _ON_TIME_STRING;
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
      case AttendanceStatus.OnTime:
        return "On Time";
    }
  }
}
