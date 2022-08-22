const _PRESENT_STRING = "PRESENT";
const _LATE_STRING = "LATE";
const _ABSENT_STRING = "ABSENT";
const _NO_ACTION_STRING = "NOACTION";
const _BREAK_STRING = "BREAK";
const _HALF_DAY_STRING = "HALFDAY";
const _EARLY_LEAVE_STRING = "EARLYLEAVE";
const _ON_TIME_STRING = "ONTIME";

enum AttendanceStatus {
  Present,
  Late,
  Absent,
  NoAction,
  Break,
  HalfDay,
  EarlyLeave,
  OnTime;

  static AttendanceStatus? initFromString(String string) {
    if (string == _PRESENT_STRING) {
      return AttendanceStatus.Present;
    } else if (string == _LATE_STRING) {
      return AttendanceStatus.Late;
    } else if (string == _ABSENT_STRING) {
      return AttendanceStatus.Absent;
    } else if (string == _NO_ACTION_STRING) {
      return AttendanceStatus.NoAction;
    } else if (string == _BREAK_STRING) {
      return AttendanceStatus.Break;
    } else if (string == _HALF_DAY_STRING) {
      return AttendanceStatus.HalfDay;
    } else if (string == _EARLY_LEAVE_STRING) {
      return AttendanceStatus.EarlyLeave;
    } else if (string == _ON_TIME_STRING) {
      return AttendanceStatus.OnTime;
    }
    return null;
  }

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
