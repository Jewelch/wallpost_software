import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/leave/entities/leave_status.dart';

class LeaveListItem extends JSONInitializable {
  String _leaveId;
  String _applicantName;
  String _applicantProfileImageUrl;
  DateTime _leaveFrom;
  DateTime _leaveTo;
  num _totalLeaveDays;
  String _leaveType;
  LeaveStatus _status;

  LeaveListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leaveTypeMap = sift.readMapFromMap(jsonMap, 'leave_type');
      var employeeMap = sift.readMapFromMap(jsonMap, 'employee');
      _leaveId = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _applicantName = sift.readStringFromMap(employeeMap, 'fullName');
      _applicantProfileImageUrl = sift.readStringFromMap(employeeMap, 'profile_image');
      _leaveFrom = sift.readDateFromMap(jsonMap, 'leave_from', 'yyyy-MM-dd');
      _leaveTo = sift.readDateFromMap(jsonMap, 'leave_to', 'yyyy-MM-dd');
      _totalLeaveDays = sift.readNumberFromMap(jsonMap, 'leave_days');
      _leaveType = sift.readStringFromMap(leaveTypeMap, 'name');
      var status = sift.readNumberFromMap(jsonMap, 'status');
      _status = _readLeaveStatus(status);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveListItem response. Error message - ${e.errorMessage}');
    }
  }

  LeaveStatus _readLeaveStatus(int status) {
    if (status == 0) {
      return LeaveStatus.pendingApproval;
    } else if (status == 1) {
      return LeaveStatus.approved;
    } else if (status == 2) {
      return LeaveStatus.rejected;
    } else {
      return LeaveStatus.cancelled;
    }
  }

  String get leaveId => _leaveId;

  String get applicantName => _applicantName;

  String get applicantProfileImageUrl => _applicantProfileImageUrl;

  DateTime get leaveFrom => _leaveFrom;

  DateTime get leaveTo => _leaveTo;

  num get totalLeaveDays => _totalLeaveDays;

  String get leaveType => _leaveType;

  LeaveStatus get status => _status;
}
