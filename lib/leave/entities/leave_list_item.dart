import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/leave/entities/leave_status.dart';

class LeaveListItem extends JSONInitializable {
  late String _leaveId;
  late String _applicantName;
  late String _applicantProfileImageUrl;
  late DateTime _leaveFrom;
  late DateTime _leaveTo;
  late num _totalLeaveDays;
  late String _leaveType;
  late LeaveStatus _status;
  String? _approvalComment;
  String? _rejectionReason;
  String? _cancellationReason;

  //TODO: Saeed Munavir - clean up this class
  LeaveListItem() : super.fromJson({}) {
    _leaveId = "${DateTime.now().millisecondsSinceEpoch}";
    _applicantName = "name";
    _applicantProfileImageUrl = "asdfasdf";
    _leaveFrom = DateTime.now();
    _leaveTo = DateTime.now();
    _totalLeaveDays = 3;
    _leaveType = "asdfasdf";
    _status = LeaveStatus.approved;
  }

  LeaveListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leaveTypeMap = sift.readMapFromMap(jsonMap, 'leave_type');
      // var employeeMap = sift.readMapFromMap(jsonMap, 'employee_detail');
      _leaveId = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _applicantName = "sift.readStringFromMap(employeeMap, 'fullName')";
      _applicantProfileImageUrl = "sift.readStringFromMap(employeeMap, 'profile_image')";
      _leaveFrom = sift.readDateFromMap(jsonMap, 'leave_from', 'yyyy-MM-dd');
      _leaveTo = sift.readDateFromMap(jsonMap, 'leave_to', 'yyyy-MM-dd');
      _totalLeaveDays = sift.readNumberFromMap(jsonMap, 'leave_days');
      _leaveType = sift.readStringFromMap(leaveTypeMap, 'name');
      var status = sift.readNumberFromMap(jsonMap, 'status');
      _status = _readLeaveStatus(status);
      _approvalComment = sift.readStringFromMapWithDefaultValue(jsonMap, 'approval_comments', null);
      _rejectionReason = sift.readStringFromMapWithDefaultValue(jsonMap, 'rejected_reason', null);
      _cancellationReason = sift.readStringFromMapWithDefaultValue(jsonMap, 'cancel_reason', null);
    } on SiftException catch (e) {
      print(e.errorMessage);
      throw MappingException('Failed to cast LeaveListItem response. Error message - ${e.errorMessage}');
    }
  }

  LeaveStatus _readLeaveStatus(num status) {
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

  String? get approvalComment => _approvalComment;

  String? get rejectionReason => _rejectionReason;

  String? get cancellationReason => _cancellationReason;
}
