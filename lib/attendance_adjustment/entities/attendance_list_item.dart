import 'package:flutter/material.dart';
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
  AttendanceStatus? _workStatus;
  AttendanceStatus? _adjustedStatus;
  late String? _adjustmentReason;
  late String? _approvalStatus;
  late String? _approverName;

  AttendanceListItem.fromJSon(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _id = sift.readNumberFromMapWithDefaultValue(jsonMap, 'id', null);
      _attendanceId = sift.readStringFromMapWithDefaultValue(
          jsonMap, 'attendance_id', null);
      _date = sift.readDateFromMap(jsonMap, 'date', 'yyyy-MM-dd');
      _punchInTime = sift.readDateFromMapWithDefaultValue(
          jsonMap, 'punch_in_time', 'HH:mm', null);
      _punchOutTime = sift.readDateFromMapWithDefaultValue(
          jsonMap, 'punch_out_time', 'HH:mm', null);
      _originalPunchInTime = sift.readDateFromMapWithDefaultValue(
          jsonMap, 'orig_punch_in_time', 'HH:mm', null);
      _originalPunchOutTime = sift.readDateFromMapWithDefaultValue(
          jsonMap, 'orig_punch_out_time', 'HH:mm', null);
      var workStatusString =
          sift.readStringFromMapWithDefaultValue(jsonMap, 'work_status', null);
      if (workStatusString != null)
        _workStatus = initializeAttendanceStatusFromString(workStatusString);
      var adjustedStatusString = sift.readStringFromMapWithDefaultValue(
          jsonMap, 'adjusted_status', null);
      if (adjustedStatusString != null)
        _adjustedStatus =
            initializeAttendanceStatusFromString(adjustedStatusString);
      _adjustmentReason =
          sift.readStringFromMapWithDefaultValue(jsonMap, 'reason', null);
      _approvalStatus = sift.readStringFromMapWithDefaultValue(
          jsonMap, 'approval_status', null);
      _approverName = sift.readStringFromMapWithDefaultValue(
          jsonMap, 'approver_name', null);
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast AttendanceListItem response. Error message - ${e.errorMessage}');
    }
  }

  num? get id => _id;

  String? get attendanceID => _attendanceId;

  DateTime get date => _date;

  String get punchInTime => _convertTimeToString(_punchInTime);

  DateTime? get punchOutTime => _punchOutTime;

  String get originalPunchInTime => _convertTimeToString(_originalPunchInTime);

  String get originalPunchOutTime =>
      _convertTimeToString(_originalPunchOutTime);

  String? get approvalStatus => _approvalStatus;

  String get adjustmentReason => _adjustmentReason ?? "";

  String? get approverName => _approverName;

  String getStatus() {
    if (_workStatus != null) return _workStatus!.toReadableString();
    if (_adjustedStatus != null) return _adjustedStatus!.toReadableString();
    return "";
  }

  Color getStatusColor() {
    if (_workStatus != null)
      return _workStatus!.statusColor();
    else
      return _adjustedStatus!.statusColor();
  }

  Color getPunchInLabelColor() {
    if (_workStatus != null)
      return _workStatus!.punchInLabelColor();
    else
      return _adjustedStatus!.punchInLabelColor();
  }

  Color getPunchOutLabelColor() {
    if (_workStatus != null)
      return _workStatus!.punchOutLabelColor();
    else
      return _adjustedStatus!.punchOutLabelColor();
  }

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
