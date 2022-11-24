import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../leave__core/entities/leave_status.dart';

class LeaveDetail extends JSONInitializable {
  late String _leaveId;
  late String _companyId;
  late String _applicantName;
  late DateTime _startDate;
  late DateTime _endDate;
  late num _totalLeaveDays;
  late num _paidDays;
  late num _unPaidDays;
  late String _contactOnLeave;
  late String _emailOnLeave;
  late String _leaveReason;
  late String _leaveType;
  late LeaveStatus _status;
  late String? _attachment;
  List<String> _pendingWithUsers = [];
  String? _approvalComment;
  String? _rejectionReason;
  String? _cancellationReason;

  LeaveDetail.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leaveTypeMap = sift.readMapFromMap(jsonMap, 'leave_type');
      var employeeMap = sift.readMapFromMap(jsonMap, 'employee');
      var extraInfoMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'extra_info', {});
      _leaveId = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _companyId = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _applicantName = '${sift.readStringFromMap(employeeMap, 'name')}';
      _startDate = sift.readDateFromMap(jsonMap, 'leave_from', 'yyyy-MM-dd');
      _endDate = sift.readDateFromMap(jsonMap, 'leave_to', 'yyyy-MM-dd');
      _totalLeaveDays = sift.readNumberFromMap(jsonMap, 'leave_days');
      _paidDays = sift.readNumberFromMap(jsonMap, 'paid_days');
      _unPaidDays = sift.readNumberFromMap(jsonMap, 'unpaid_days');
      _contactOnLeave = sift.readStringFromMap(jsonMap, 'contact_on_leave');
      _emailOnLeave = sift.readStringFromMap(jsonMap, 'contact_email');
      _leaveReason = sift.readStringFromMap(jsonMap, 'leave_reason');
      _leaveType = sift.readStringFromMap(leaveTypeMap, 'name');
      _status = _readLeaveStatus(jsonMap);
      _attachment = _readAttachment(jsonMap);
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

  String? _readAttachment(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    var attachmentList = sift.readMapListFromMapWithDefaultValue(jsonMap, "attach_doc", [])!;
    if (attachmentList.isNotEmpty) {
      var attachmentMap = sift.readMapFromList(attachmentList, 0);
      return sift.readStringFromMapWithDefaultValue(attachmentMap, "attachment", null);
    }
    return null;
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

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  num get totalLeaveDays => _totalLeaveDays;

  num get paidDays => _paidDays;

  num get unPaidDays => _unPaidDays;

  String get contactOnLeave => _contactOnLeave;

  String get emailOnLeave => _emailOnLeave;

  String get leaveReason => _leaveReason;

  String get leaveType => _leaveType;

  String get statusString => _status.toReadableString();

  String? get attachmentUrl => _attachment;

  String? get pendingWithUsers => _pendingWithUsers.isEmpty ? null : _pendingWithUsers.join(", ");

  String? get approvalComment => _approvalComment;

  String? get rejectionReason => _rejectionReason;

  String? get cancellationReason => _cancellationReason;
}
