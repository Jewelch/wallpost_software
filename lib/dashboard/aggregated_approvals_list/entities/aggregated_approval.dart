import 'package:sift/Sift.dart';
import 'package:wallpost/_wp_core/company_management/entities/module.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/json_serialization_base/json_initializable.dart';

class AggregatedApproval extends JSONInitializable {
  late String _companyId;
  late String _companyName;
  late String _approvalType;
  late Module _module;
  late String _moduleColor;
  late int _approvalCount;

  AggregatedApproval.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _companyId = "${sift.readNumberFromMap(jsonMap, 'comapnyId')}";
      _companyName = sift.readStringFromMap(jsonMap, 'companyName');
      _approvalType = sift.readStringFromMap(jsonMap, 'approvalType');
      _module = _readModule(jsonMap);
      _moduleColor = sift.readStringFromMap(jsonMap, 'moduleColor');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approvalCount').toInt();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AggregatedApproval response. Error message - ${e.errorMessage}');
    }
  }

  Module _readModule(Map<String, dynamic> jsonMap) {
    var moduleString = Sift().readStringFromMap(jsonMap, 'module');
    var module = Module.initFromString(moduleString);

    if (module == null)
      throw MappingException('Failed to cast AggregatedApproval response. Invalid module - $moduleString');

    return module;
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

  bool isBillRequestApproval() {
    return _approvalType == "Bill Request";
  }

  void setCount(int count) {
    _approvalCount = count;
  }

  String get companyId => _companyId;

  String get companyName => _companyName;

  String get approvalType => _approvalType;

  Module get module => _module;

  String get moduleColor => _moduleColor;

  int get approvalCount => _approvalCount;
}
