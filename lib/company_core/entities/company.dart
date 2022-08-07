import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/company_core/entities/module.dart';

class Company extends JSONInitializable {
  late String _id;
  late String _accountNumber;
  late String _name;
  late String _shortName;
  late String _commercialName;
  late String _logoUrl;
  late String _dateFormat;
  late String _currency;
  late bool _shouldShowRevenue;
  late List<Module> _modules;
  late bool _showTimeSheet;
  late String _timezone;
  late num _allowedPunchInRadiusInMeters;
  late bool _isTrial;
  late String _fileUploadPath;

  Company.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var companyInfoMap = sift.readMapFromMap(jsonMap, 'company_info');
      _id = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _accountNumber = '${sift.readNumberFromMap(jsonMap, 'account_no')}';
      _name = sift.readStringFromMap(jsonMap, 'company_name');
      _shortName = sift.readStringFromMap(jsonMap, 'short_name');
      _commercialName = sift.readStringFromMap(jsonMap, 'commercial_name');
      _logoUrl = sift.readStringFromMap(jsonMap, 'company_logo');
      _dateFormat = sift.readStringFromMap(companyInfoMap, 'js_date_format');
      _currency = sift.readStringFromMap(companyInfoMap, 'currency');
      _shouldShowRevenue = sift.readNumberFromMap(jsonMap, 'show_revenue') == 0 ? false : true;
      var _packages = sift.readStringListFromMap(jsonMap, 'packages');
      _modules = _initModules(_packages);
      _showTimeSheet = sift.readBooleanFromMap(companyInfoMap, 'show_timesheet_icon');
      _timezone = sift.readStringFromMap(companyInfoMap, 'time_zone');
      _allowedPunchInRadiusInMeters = sift.readNumberFromMap(companyInfoMap, 'allowed_radius');
      _isTrial = sift.readStringFromMap(companyInfoMap, 'is_trial') == 'true';
      _fileUploadPath = sift.readStringFromMap(jsonMap, 'absolute_upload_path');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Company response. Error message - ${e.errorMessage}');
    } on MappingException {
      rethrow;
    }
  }

  List<Module> _initModules(List<String> moduleStrings) {
    List<Module> modules = [];
    moduleStrings.forEach((moduleString) {
      var module = initializeModuleFromString(moduleString);
      if (module != null) modules.add(module);
    });
    return modules;
  }

  String get fileUploadPath => _fileUploadPath;

  bool get isTrial => _isTrial;

  num get allowedPunchInRadiusInMeters => _allowedPunchInRadiusInMeters;

  String get timezone => _timezone;

  bool get showTimeSheet => _showTimeSheet;

  List<Module> get modules => _modules;

  bool get shouldShowRevenue => _shouldShowRevenue;

  String get currency => _currency;

  String get dateFormat => _dateFormat.replaceAll('D', 'd').replaceAll('Y', 'y');

  String get logoUrl => _logoUrl;

  String get commercialName => _commercialName;

  String get shortName => _shortName;

  String get name => _name;

  String get accountNumber => _accountNumber;

  String get id => _id;
}
