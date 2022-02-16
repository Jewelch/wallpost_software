import 'package:intl/intl.dart';
import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';

class AttendanceListItem extends JSONInitializable {
  late num? _id;
  late String? _attendanceId;
  late DateTime _date;
  late DateTime? _punchInTime;
  late DateTime? _punchOutTime;
  late DateTime? _originalPunchInTime;
  late DateTime? _originalPunchOutTime;
  late AttendanceStatus _status;
  late String? _adjustmentReason;
  late String? _approvalStatus;
  late String? _approverName;

  AttendanceListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _id = sift.readNumberFromMapWithDefaultValue(jsonMap, 'id', null);
      _attendanceId = sift.readStringFromMapWithDefaultValue(jsonMap, 'attendance_id', null);
      _date = sift.readDateFromMap(jsonMap, 'date', 'yyyy-MM-dd');
      _punchInTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'punch_in_time', 'HH:mm', null);
      _punchOutTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'punch_out_time', 'HH:mm', null);
      _originalPunchInTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'orig_punch_in_time', 'HH:mm', null);
      _originalPunchOutTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'orig_punch_out_time', 'HH:mm', null);
      _status = _readStatus(jsonMap);
      _adjustmentReason = sift.readStringFromMapWithDefaultValue(jsonMap, 'reason', null);
      _approvalStatus = sift.readStringFromMapWithDefaultValue(jsonMap, 'approval_status', null);
      _approverName = sift.readStringFromMapWithDefaultValue(jsonMap, 'approver_name', null);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AttendanceListItem response. Error message - ${e.errorMessage}');
    }
  }

  AttendanceStatus _readStatus(Map<String, dynamic> jsonMap) {
    var sift = Sift();

    String? statusString;
    statusString = sift.readStringFromMapWithDefaultValue(jsonMap, 'work_status', null);
    if (statusString == null) {
      statusString = sift.readStringFromMap(jsonMap, 'adjusted_status');
    }

    AttendanceStatus? status = initializeAttendanceStatusFromString(statusString);
    if (status == null) {
      throw MappingException("Failed to cast AttendanceListItem response. Error message - could not initialize status");
    }

    return status;
  }

  //MARK: Getters

  num? get id => _id;

  String? get attendanceID => _attendanceId;

  DateTime get date => _date;

  DateTime? get punchInTime => _punchInTime;

  DateTime? get punchOutTime => _punchOutTime;

  String get originalPunchInTime => _convertTimeToString(_originalPunchInTime);

  String get originalPunchOutTime => _convertTimeToString(_originalPunchOutTime);

  AttendanceStatus get status => _status;

  String? get approvalStatus => _approvalStatus;

  String get adjustmentReason => _adjustmentReason ?? "";

  String? get approverName => _approverName;

  String getReadableDate() {
    return _convertDateToString(_date);
  }

  String getPunchInReadableTime() {
    return _convertTimeToString(_punchInTime);
  }

  String getPunchOutReadableTime() {
    return _convertTimeToString(_punchOutTime);
  }

  //MARK: Util functions

  String _convertTimeToString(DateTime? time) {
    if (time == null) return '';
    return DateFormat('hh:mm a').format(time);
  }

  String _convertDateToString(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy - EEE').format(date);
  }
}
