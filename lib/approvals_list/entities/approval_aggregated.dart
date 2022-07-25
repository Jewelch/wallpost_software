import 'package:sift/Sift.dart';
import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class ApprovalAggregated extends JSONInitializable {
  late num _companyId;
  late String _companyName;
  late String _approvalType;
  late String _module;
  late String _moduleId;
  late String _moduleColor;
  late num _approvalCount;


  ApprovalAggregated.builder(this._companyId, this._companyName, this._approvalType,
      this._module, this._moduleId, this._moduleColor, this._approvalCount) : super.fromJson(Map());


  ApprovalAggregated.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _companyId = sift.readNumberFromMap(jsonMap, 'comapnyId');
      _companyName = sift.readStringFromMap(jsonMap, 'companyName');
      _approvalType = sift.readStringFromMap(jsonMap, 'approvalType');
      _module = sift.readStringFromMap(jsonMap, 'module');
      _moduleId = sift.readStringFromMap(jsonMap, 'moduleId');
      _moduleColor = sift.readStringFromMap(jsonMap, 'moduleColor');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approvalCount');

    } on SiftException catch (e) {
      throw MappingException('Failed to cast Approval response. Error message - ${e.errorMessage}');
    }
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'comapnyId': _companyId,
      'companyName': _companyName,
      'approvalType': _approvalType,
      "module": _module,
      'moduleId': _moduleId,
      'moduleColor': _moduleColor,
      'approvalCount': _approvalCount,
    };
    return jsonMap;
  }

  num get companyId => _companyId;
  String get companyName => _companyName;
  String get approvalType => _approvalType;
  String get module => _module;
  String get moduleId => _moduleId;
  String get moduleColor => _moduleColor;
  num get approvalCount => _approvalCount;

}