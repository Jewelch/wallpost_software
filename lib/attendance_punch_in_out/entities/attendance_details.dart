import 'package:intl/intl.dart';
import 'package:sift/sift.dart';

import 'break.dart';

class AttendanceDetails  {
  String? _id;
  String? _detailsId;
  DateTime? _punchInTime;
  DateTime? _punchOutTime;
  List<Break> _breaks = [];

  late bool _canMarkAttendancePermissionFromApp;
  late bool _canMarkAttendanceNow;
  late num _secondsTillPunchIn;

  //TODO add attendance_punch_in_out status

  AttendanceDetails.fromJson(Map<String, dynamic> jsonMap)  {
    var sift = Sift();
    var attendanceInfoMapList = sift.readMapListFromMapWithDefaultValue(jsonMap, 'attendance_info', null);
    var attendanceInfoMap = sift.readMapFromListWithDefaultValue(attendanceInfoMapList, 0, null);
    var attendanceDetailsMapList =
        sift.readMapListFromMapWithDefaultValue(attendanceInfoMap, 'attendance_details', null);
    var attendanceDetailsMap = sift.readMapFromListWithDefaultValue(attendanceDetailsMapList, 0, null);
    var breaksMapList = sift.readMapListFromMapWithDefaultValue(attendanceDetailsMap, 'attendance_intervals', null);
    var attendancePermissionMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'is_allowed_punchin', null);
    _id = sift.readStringFromMapWithDefaultValue(attendanceInfoMap, 'attendance_id', null);
    _detailsId = sift.readStringFromMapWithDefaultValue(attendanceDetailsMap, 'attendance_details_id', null);
    _punchInTime =
        sift.readDateFromMapWithDefaultValue(attendanceDetailsMap, 'actual_punch_in', 'yyyy-MM-dd HH:mm:ss', null);
    _punchOutTime =
        sift.readDateFromMapWithDefaultValue(attendanceDetailsMap, 'actual_punch_out', 'yyyy-MM-dd HH:mm:ss', null);
    _breaks = _readBreakFromMapList(breaksMapList);
    _canMarkAttendancePermissionFromApp = sift.readBooleanFromMap(attendancePermissionMap, 'punch_in_allowed_from_app');
    _canMarkAttendanceNow = sift.readBooleanFromMap(attendancePermissionMap, 'status');
    _secondsTillPunchIn = sift.readNumberFromMapWithDefaultValue(attendancePermissionMap, 'remaining_in_min', 0)!;
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

  String? get attendanceId => _id;

  String? get attendanceDetailsId => _detailsId;

  String get punchInTimeString => _convertTimeToString(_punchInTime);

  String get punchOutTimeString => _convertTimeToString(_punchOutTime);

  String get activeBreakStartTimeString {
    return _convertTimeToString(_getActiveBreak()?.startTime);
  }

  String? get activeBreakId {
    var activeBreak = _getActiveBreak();
    if (activeBreak == null) return null;
    return activeBreak.id;
  }

  bool get isNotPunchedIn {
    return _punchInTime == null && _canMarkAttendanceNow==true;
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

  bool get canMarkAttendancePermissionFromApp => _canMarkAttendancePermissionFromApp;

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
