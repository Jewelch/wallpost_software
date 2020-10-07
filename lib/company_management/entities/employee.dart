import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class Employee extends JSONInitializable {
  String _employeeId;
  num _employeeIdV1;
  String _employeeName;
  String _employeeEmail;
  String _designation;
  String _lineManager;
  String _companyCurrency;
  String _companyDateFormat;
  String _departmentRank;
  num _allowedPunchInOutRadius;
  bool _showTimeSheet;
  String _fileUploadPath;
  String _isTrial;

  Employee.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var employeeMap = sift.readMapFromMap(jsonMap, 'employee');
      var departmentRankMap = sift.readMapFromMap(jsonMap, 'department_rank');
      var companyInfoMap = sift.readMapFromMap(jsonMap, 'company_info');
      _employeeId = sift.readStringFromMap(employeeMap, 'employment_id');
      _employeeIdV1 = sift.readNumberFromMap(employeeMap, 'employment_id_v1');
      _employeeName = sift.readStringFromMap(employeeMap, 'name');
      _employeeEmail = sift.readStringFromMap(employeeMap, 'email_id_office');
      _designation = sift.readStringFromMap(employeeMap, 'designation');
      _lineManager = sift.readStringFromMap(employeeMap, 'line_manager');
      _companyCurrency = sift.readStringFromMap(companyInfoMap, 'currency');
      _companyDateFormat = sift.readStringFromMap(companyInfoMap, 'js_date_format');
      var rank = sift.readNumberFromMap(departmentRankMap, 'rank');
      var rankOutOf = sift.readNumberFromMap(departmentRankMap, 'out_of');
      _departmentRank = '$rank/$rankOutOf';
      _allowedPunchInOutRadius = sift.readNumberFromMap(companyInfoMap, 'allowed_radius');
      _showTimeSheet = sift.readBooleanFromMap(companyInfoMap, 'show_timesheet_icon');
      _fileUploadPath = sift.readStringFromMap(jsonMap, 'absolute_upload_path');
      _isTrial = sift.readStringFromMap(companyInfoMap, 'is_trial');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Employee response. Error message - ${e.errorMessage}');
    }
  }

  String get employeeId => _employeeId;

  num get employeeIdV1 => _employeeIdV1;

  String get employeeName => _employeeName;

  String get employeeEmail => _employeeEmail;

  String get designation => _designation;

  String get lineManager => _lineManager;

  String get companyCurrency => _companyCurrency;

  String get companyDateFormat => _companyDateFormat;

  String get departmentRank => _departmentRank;

  num get allowedPunchInOutRadius => _allowedPunchInOutRadius;

  bool get showTimeSheet => _showTimeSheet;

  String get fileUploadPath => _fileUploadPath;

  String get isTrial => _isTrial;
}
