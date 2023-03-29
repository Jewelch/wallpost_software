import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../leave__core/entities/leave_status.dart';

class LeaveListItem extends JSONInitializable {
  late String _leaveId;
  late String _companyId;
  late String _applicantName;
  late String _applicantProfileImageUrl;
  late DateTime _startDate;
  late DateTime _endDate;
  late num _totalLeaveDays;
  late String _leaveType;
  late LeaveStatus _status;
  List<String> _pendingWithUsers = [];
  String? _approvalComment;
  String? _rejectionReason;
  String? _cancellationReason;

  LeaveListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leaveTypeMap = sift.readMapFromMap(jsonMap, 'leave_type');
      var extraInfoMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'extra_info', {});
      _leaveId = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _companyId = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _applicantName = "sift.readStringFromMap(employeeMap, 'fullName')";
      _applicantProfileImageUrl = "sift.readStringFromMap(employeeMap, 'profile_image')";
      _startDate = sift.readDateFromMap(jsonMap, 'leave_from', 'yyyy-MM-dd');
      _endDate = sift.readDateFromMap(jsonMap, 'leave_to', 'yyyy-MM-dd');
      _totalLeaveDays = sift.readNumberFromMap(jsonMap, 'leave_days');
      _leaveType = sift.readStringFromMap(leaveTypeMap, 'name');
      _status = _readLeaveStatus(jsonMap);
      _pendingWithUsers = sift.readStringListFromMapWithDefaultValue(extraInfoMap, "pending_with_users", [])!;
      _approvalComment = sift.readStringFromMapWithDefaultValue(jsonMap, 'approval_comments', null);
      _rejectionReason = sift.readStringFromMapWithDefaultValue(jsonMap, 'rejected_reason', null);
      _cancellationReason = sift.readStringFromMapWithDefaultValue(jsonMap, 'cancel_reason', null);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveListItem response. Error message - ${e.errorMessage}');
    }
  }

  LeaveStatus _readLeaveStatus(Map<String, dynamic> jsonMap) {
    var statusInt = Sift().readNumberFromMap(jsonMap, "status");
    var status = LeaveStatus.initFromInt(statusInt.toInt());

    if (status == null) throw MappingException('Failed to cast LeaveListItem response. Invalid status - $statusInt');

    return status;
  }

  bool isApproved() {
    return _status == LeaveStatus.approved;
  }

  bool isPendingApproval() {
    return _status == LeaveStatus.pendingApproval;
  }

  bool isRejected() {
    return _status == LeaveStatus.rejected;
  }

  bool isCancelled() {
    return _status == LeaveStatus.cancelled;
  }

  String get leaveId => _leaveId;

  String get companyId => _companyId;

  String get applicantName => _applicantName;

  String get applicantProfileImageUrl => _applicantProfileImageUrl;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  num get totalLeaveDays => _totalLeaveDays;

  String get leaveType => _leaveType;

  String get statusString => _status.toReadableString();

  String? get pendingWithUsers => _pendingWithUsers.isEmpty ? null : _pendingWithUsers.join(", ");

  String? get approvalComment => _approvalComment;

  String? get rejectionReason => _rejectionReason;

  String? get cancellationReason => _cancellationReason;
}
