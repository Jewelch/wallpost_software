import 'package:intl/intl.dart';
import 'package:sift/sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import 'break.dart';

class AttendanceDetails {
  //if not applicable - the user does not have access to attendance module or does not have to mark attendance
  late bool _isAttendanceApplicable;
  String? _id;
  String? _detailsId;
  DateTime? _punchInTime;
  DateTime? _punchOutTime;
  List<Break> _breaks = [];
  late bool _canMarkAttendanceFromApp;
  late bool _canMarkAttendanceNow;
  late num _secondsTillPunchIn;

  AttendanceDetails.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      var attendanceInfoMapList = sift.readMapListFromMapWithDefaultValue(jsonMap, 'attendance_info', null);
      var attendanceInfoMap = sift.readMapFromListWithDefaultValue(attendanceInfoMapList, 0, null);
      var attendanceDetailsMapList =
          sift.readMapListFromMapWithDefaultValue(attendanceInfoMap, 'attendance_details', null);
      var attendanceDetailsMap = sift.readMapFromListWithDefaultValue(attendanceDetailsMapList, 0, null);
      var breaksMapList = sift.readMapListFromMapWithDefaultValue(attendanceDetailsMap, 'attendance_intervals', null);
      var attendancePermissionMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'is_allowed_punchin', null);
      _isAttendanceApplicable = sift.readStringFromMap(jsonMap, "is_punching_required") == 'true';
      _id = sift.readStringFromMapWithDefaultValue(attendanceInfoMap, 'attendance_id', null);
      _detailsId = sift.readStringFromMapWithDefaultValue(attendanceDetailsMap, 'attendance_details_id', null);
      _punchInTime =
          sift.readDateFromMapWithDefaultValue(attendanceDetailsMap, 'actual_punch_in', 'yyyy-MM-dd HH:mm:ss', null);
      _punchOutTime =
          sift.readDateFromMapWithDefaultValue(attendanceDetailsMap, 'actual_punch_out', 'yyyy-MM-dd HH:mm:ss', null);
      _breaks = _readBreakFromMapList(breaksMapList);
      _canMarkAttendanceFromApp = sift.readBooleanFromMap(attendancePermissionMap, 'punch_in_allowed_from_app');
      _canMarkAttendanceNow = sift.readBooleanFromMap(attendancePermissionMap, 'status');
      _secondsTillPunchIn = sift.readNumberFromMapWithDefaultValue(attendancePermissionMap, 'remaining_in_min', 0)!;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AttendanceDetails response. Error message - ${e.errorMessage}');
    }
  }

  List<Break> _readBreakFromMapList(List<Map<String, dynamic>>? jsonMapList) {
    if (jsonMapList == null) {
      return [];
    }

    var items = <Break>[];
    for (var jsonMap in jsonMapList) {
      try {
        var item = Break.fromJson(jsonMap);
        items.add(item);
      } catch (e) {
        //ignore as this is not a critical error
      }
    }
    return items;
  }

  //MARK: Getters

  bool get isNotPunchedIn {
    return _punchInTime == null && _canMarkAttendanceNow == true;
  }

  bool get isPunchedIn {
    return _punchInTime != null && _punchOutTime == null;
  }

  bool get isPunchedOut {
    return _punchOutTime != null;
  }

  bool get isOnBreak {
    return isPunchedIn == true && _getActiveBreak() != null;
  }

  String? get activeBreakId {
    var activeBreak = _getActiveBreak();
    if (activeBreak == null) return null;
    return activeBreak.id;
  }

  String get activeBreakStartTimeString {
    return _convertTimeToString(_getActiveBreak()?.startTime);
  }

  bool get isAttendanceApplicable => _isAttendanceApplicable;

  String? get attendanceId => _id;

  String? get attendanceDetailsId => _detailsId;

  String get punchInTimeString => _convertTimeToString(_punchInTime);

  String get punchOutTimeString => _convertTimeToString(_punchOutTime);

  bool get canMarkAttendanceFromApp => _canMarkAttendanceFromApp;

  bool get canMarkAttendanceNow => _canMarkAttendanceNow;

  num get secondsTillPunchIn => _secondsTillPunchIn;

  //MARK: Util functions

  String _convertTimeToString(DateTime? time) {
    if (time == null) return '';
    return DateFormat('hh:mm a').format(time);
  }

  Break? _getActiveBreak() {
    var activeBreaks = _breaks.where((element) => element.isActive());
    if (activeBreaks.isNotEmpty) {
      return activeBreaks.first;
    } else {
      return null;
    }
  }
}
