import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class Employee extends JSONInitializable implements JSONConvertible {
  String _v1Id;
  String _v2Id;
  String _companyId;
  String _employeeName;
  String _employeeEmail;
  String _designation;
  String _lineManager;
  String _departmentRank;

  Employee.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var employeeMap = sift.readMapFromMap(jsonMap, 'employee');
      var departmentRankMap = sift.readMapFromMap(jsonMap, 'department_rank');
      _v1Id = '${sift.readNumberFromMap(employeeMap, 'employment_id_v1')}';
      _v2Id = sift.readStringFromMap(employeeMap, 'employment_id');
      _companyId = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _employeeName = sift.readStringFromMap(employeeMap, 'name');
      _employeeEmail = sift.readStringFromMap(employeeMap, 'email_id_office');
      _designation = sift.readStringFromMap(employeeMap, 'designation');
      _lineManager = sift.readStringFromMapWithDefaultValue(employeeMap, 'line_manager', null);
      var rank = sift.readNumberFromMapWithDefaultValue(departmentRankMap, 'rank', null);
      var rankOutOf = sift.readNumberFromMapWithDefaultValue(departmentRankMap, 'out_of', null);
      _departmentRank = (rank == null || rankOutOf == null) ? '' : '$rank/$rankOutOf';
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Employee response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map employeeMap = {};
    employeeMap['employment_id_v1'] = int.parse(_v1Id);
    employeeMap['employment_id'] = _v2Id;
    employeeMap['name'] = _employeeName;
    employeeMap['email_id_office'] = _employeeEmail;
    employeeMap['designation'] = _designation;
    employeeMap['line_manager'] = _lineManager;

    Map departmentRankMap = {};
    departmentRankMap['rank'] = int.parse(_departmentRank.split('/')[0]);
    departmentRankMap['out_of'] = int.parse(_departmentRank.split('/')[1]);

    Map<String, dynamic> jsonMap = {
      'employee': employeeMap,
      'department_rank': departmentRankMap,
      'company_id': int.parse(_companyId)
    };
    return jsonMap;
  }

  String get companyId => _companyId;

  String get v1Id => _v1Id;
}
