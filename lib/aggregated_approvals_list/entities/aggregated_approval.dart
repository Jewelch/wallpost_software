import 'package:sift/Sift.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class AggregatedApproval extends JSONInitializable {
  late String _companyId;
  late String _companyName;
  late String _approvalType;
  late String _module;
  late String _moduleColor;
  late int _approvalCount;

  AggregatedApproval.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _companyId = "${sift.readNumberFromMap(jsonMap, 'comapnyId')}";
      _companyName = sift.readStringFromMap(jsonMap, 'companyName');
      _approvalType = sift.readStringFromMap(jsonMap, 'approvalType');
      _module = sift.readStringFromMap(jsonMap, 'module');
      _moduleColor = sift.readStringFromMap(jsonMap, 'moduleColor');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approvalCount').toInt();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Approval response. Error message - ${e.errorMessage}');
    }
  }

  bool isAttendanceAdjustmentApproval() {
    return _approvalType == "Attendance Adjustment";
  }

  bool isExpenseRequestApproval() {
    return _approvalType == "Expense Request";
  }

  bool isLeaveRequestApproval() {
    return _approvalType == "Leave Request";
  }

  String get companyId => _companyId;

  String get companyName => _companyName;

  String get approvalType => _approvalType;

  String get module => _module;

  String get moduleColor => _moduleColor;

  int get approvalCount => _approvalCount;
}
