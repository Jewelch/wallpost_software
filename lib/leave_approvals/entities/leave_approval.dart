import 'package:sift/Sift.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval_status.dart';

import '../../_shared/exceptions/mapping_exception.dart';

class LeaveApproval {
  late String _id;
  late String _companyId;
  late String _employeeName;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _numberOfDays;
  late LeaveApprovalStatus _approvalStatus;
  late String _approverName;

  LeaveApproval.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      _id = "${sift.readNumberFromMap(jsonMap, "id")}";
      _companyId = "ask Niyas to add company id"; //TODO: add company id
      _employeeName = "Some Employee Name"; //TODO: add employee name
      _startDate = sift.readDateFromMap(jsonMap, "leave_from", "MMM/dd/yyyy");
      _endDate = sift.readDateFromMap(jsonMap, "leave_to", "MMM/dd/yyyy");
      _numberOfDays = sift.readNumberFromMap(jsonMap, "leave_days").toInt();
      String approvalStatusString = sift.readStringFromMap(jsonMap, "decision_status");
      _approvalStatus = LeaveApprovalStatus.initFromString(approvalStatusString);
      _approverName = sift.readStringFromMap(jsonMap, "approve_request_by");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveApproval response. Error message - ${e.errorMessage}');
    }
  }
}
