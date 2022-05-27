import 'package:sift/Sift.dart';
import 'package:wallpost/approvals/entities/expense_request_approval.dart';
import 'package:wallpost/approvals/entities/leave_approval.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';
import 'attendance_adjustment_approval.dart';

class Approval extends JSONInitializable {
  late num _id;
  late num _companyId;
  late dynamic _details;

  Approval.fromJson(dynamic json) : super.fromJson(json) {
    var sift = Sift();
    try {
      var approvalType = '${sift.readStringFromMap(json, 'approvalType')}';
      _id = sift.readNumberFromMap(json, 'id');
      _companyId = sift.readNumberFromMap(json, 'company_id');
      var detailsMap = sift.readMapfromMap(json , 'details');
      switch (approvalType) {
        case "leaveApproval":
          _details = LeaveApproval.fromJson(json['details']);
          break;
        case "expenseRequestApproval":
          _details = ExpenseRequestApproval.fromJson(json['details']);
          break;
        case "attendanceAdjustment":
          _details = AttendanceAdjustmentApproval.fromJson(json['details']);
          break;
      }
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Approval response. Error message - ${e.errorMessage}');
    }
  }

  // String? get approvalType => _approvalType;

  num get id => _id;

  num get companyId => _companyId;

  dynamic get details => _details;

  bool isLeaveApproval() {
    return _details is LeaveApproval;
  }

  bool isAtAdApproval() {
    return _details is AttendanceAdjustmentApproval;
  }

  bool isExpReqApp() {
    return _details is ExpenseRequestApproval;
  }
}
