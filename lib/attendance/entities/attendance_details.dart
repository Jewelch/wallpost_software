import 'package:intl/intl.dart';
import 'package:sift/sift.dart';

import 'break.dart';

class AttendanceDetails {
  String? _id;
  String? _detailsId;
  DateTime? _punchInTime;
  DateTime? _punchOutTime;
  List<Break> _breaks = [];

  AttendanceDetails.fromJson(List<Map<String, dynamic>> jsonMapList) {
    var sift = Sift();
    var currentAttendanceMap = sift.readMapFromListWithDefaultValue(jsonMapList, 0, {});
    var attendanceDetailsMapList =
        sift.readMapListFromMapWithDefaultValue(currentAttendanceMap, 'attendance_details', null);
    var attendanceDetailsMap = sift.readMapFromListWithDefaultValue(attendanceDetailsMapList, 0, null);
    var breaksMapList = sift.readMapListFromMapWithDefaultValue(attendanceDetailsMap, 'attendance_intervals', null);
    _id = sift.readStringFromMapWithDefaultValue(currentAttendanceMap, 'attendance_id', null);
    _detailsId = sift.readStringFromMapWithDefaultValue(attendanceDetailsMap, 'attendance_details_id', null);
    _punchInTime =
        sift.readDateFromMapWithDefaultValue(attendanceDetailsMap, 'actual_punch_in', 'yyyy-MM-dd HH:mm:ss', null);
    _punchOutTime =
        sift.readDateFromMapWithDefaultValue(attendanceDetailsMap, 'actual_punch_out', 'yyyy-MM-dd HH:mm:ss', null);
    _breaks = _readBreakFromMapList(breaksMapList);
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

  bool get isPunchedIn {
    return _punchInTime != null && _punchOutTime == null;
  }

  bool get isOnBreak {
    return isPunchedIn == true && _getActiveBreak() != null;
  }

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
