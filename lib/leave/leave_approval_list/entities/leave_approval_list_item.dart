import 'package:sift/Sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class LeaveApprovalListItem {
  late String _id;
  late String _companyId;
  late String _leaveType;
  late String _applicantName;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _totalLeaveDays;

  LeaveApprovalListItem.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      var leaveTypeMap = sift.readMapFromMap(jsonMap, "leave_type");
      _id = "${sift.readNumberFromMap(jsonMap, "id")}";
      _leaveType = sift.readStringFromMap(leaveTypeMap, "name");
      _companyId = "${sift.readNumberFromMap(jsonMap, "company_id")}";
      _applicantName = "Some Employee Name"; //TODO: add employee name
      _startDate = sift.readDateFromMap(jsonMap, "leave_from", "dd/MM/yyyy");
      _endDate = sift.readDateFromMap(jsonMap, "leave_to", "dd/MM/yyyy");
      _totalLeaveDays = sift.readNumberFromMap(jsonMap, "leave_days").toInt();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveApproval response. Error message - ${e.errorMessage}');
    }
  }

  String get id => _id;

  String get companyId => _companyId;

  String get leaveType => _leaveType;

  String get applicantName => _applicantName;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  int get totalLeaveDays => _totalLeaveDays;
}
