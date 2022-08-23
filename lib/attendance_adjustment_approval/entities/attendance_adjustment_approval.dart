import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../attendance__core/entities/attendance_status.dart';

class AttendanceAdjustmentApproval extends JSONInitializable {
  late String _id;
  late String _companyId;
  late String _employeeId;
  late String _employeeName;
  late DateTime _attendanceDate;
  late DateTime? _originalPunchInTime;
  late DateTime? _originalPunchOutTime;
  late DateTime _adjustedPunchInTime;
  late DateTime _adjustedPunchOutTime;
  late AttendanceStatus? _originalStatus;
  late AttendanceStatus? _adjustedStatus;
  late String _adjustmentReason;

  AttendanceAdjustmentApproval.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "id")}";
      _companyId = "${sift.readNumberFromMap(jsonMap, "company_id")}";
      _employeeId = "${sift.readNumberFromMap(jsonMap, "emp_id")}";
      _employeeName = sift.readStringFromMap(jsonMap, "name");
      _attendanceDate = sift.readDateFromMap(jsonMap, "date", "yyyy-MM-dd");
      _originalPunchInTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'punch_in', 'yyyy-MM-dd HH:mm', null);
      _originalPunchOutTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'punch_out', 'yyyy-MM-dd HH:mm', null);
      _adjustedPunchInTime = sift.readDateFromMap(jsonMap, 'adjusted_punchin', 'yyyy-MM-dd HH:mm');
      _adjustedPunchOutTime = sift.readDateFromMap(jsonMap, 'adjusted_punchout', 'yyyy-MM-dd HH:mm');
      _originalStatus = _readOriginalStatus(jsonMap);
      _adjustedStatus = _readAdjustedStatus(jsonMap);
      _adjustmentReason = sift.readStringFromMap(jsonMap, "reason");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AttendanceListItem response. Error message - ${e.errorMessage}');
    }
  }

  AttendanceStatus? _readOriginalStatus(Map<String, dynamic> jsonMap) {
    var statusString = Sift().readStringFromMapWithDefaultValue(jsonMap, 'work_status', null);

    if (statusString == null) return null;
    return AttendanceStatus.initFromString(statusString);
  }

  AttendanceStatus? _readAdjustedStatus(Map<String, dynamic> jsonMap) {
    var statusString = Sift().readStringFromMapWithDefaultValue(jsonMap, 'adjusted_status', null);

    if (statusString == null) return null;
    return AttendanceStatus.initFromString(statusString);
  }

  String get id => _id;

  String get companyId => _companyId;

  String get employeeId => _employeeId;

  String get employeeName => _employeeName;

  DateTime get attendanceDate => _attendanceDate;

  DateTime? get originalPunchInTime => _originalPunchInTime;

  DateTime? get originalPunchOutTime => _originalPunchOutTime;

  DateTime get adjustedPunchInTime => _adjustedPunchInTime;

  DateTime get adjustedPunchOutTime => _adjustedPunchOutTime;

  AttendanceStatus? get originalStatus => _originalStatus;

  AttendanceStatus? get adjustedStatus => _adjustedStatus;

  String get adjustmentReason => _adjustmentReason;
}
