import 'package:sift/Sift.dart';
import 'package:wallpost/approvals/entities/expense_request_approval.dart';
import 'package:wallpost/approvals/entities/leave_approval.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';
import 'attendance_adjustment_approval.dart';

class Approval extends JSONInitializable {
  late String _id;
  late String _companyId;

  Approval.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _id = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _companyId = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Approval response. Error message - ${e.errorMessage}');
    }
  }

  bool isLeaveApproval() {
    return false;
  }

  bool isAtAdApproval() {
    return this is AttendanceAdjustmentApproval;
  }

  bool isExpReqApp() {
    return this is ExpenseRequestApproval;
  }

  String get id => _id;

  String get companyId => _companyId;
}