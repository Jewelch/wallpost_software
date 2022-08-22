import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/company_core/entities/module.dart';

import 'employee.dart';
import 'financial_summary.dart';

class Company extends JSONInitializable {
  late String _id;
  late String _accountNumber;
  late String _name;
  late String _shortName;
  late String _commercialName;
  late String _logoUrl;
  late String _dateFormat;
  late String _currency;
  late List<Module> _modules;
  late num _approvalCount;
  FinancialSummary? _financialSummary;
  late Employee _employee;

  Company.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var companyInfoMap = sift.readMapFromMap(jsonMap, 'company_info');
      var financialSummaryMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'financial_summary', null);
      _id = '${sift.readNumberFromMap(companyInfoMap, 'company_id')}';
      _accountNumber = '${sift.readNumberFromMap(companyInfoMap, 'account_no')}';
      _name = sift.readStringFromMap(companyInfoMap, 'company_name');
      _shortName = sift.readStringFromMap(companyInfoMap, 'short_name');
      _commercialName = sift.readStringFromMap(companyInfoMap, 'commercial_name');
      _logoUrl = sift.readStringFromMap(companyInfoMap, 'company_logo');
      _dateFormat = _initDateFormat(companyInfoMap);
      _currency = sift.readStringFromMap(companyInfoMap, 'currency');
      var _packages = sift.readStringListFromMap(companyInfoMap, 'packages');
      _modules = _initModules(_packages);
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approval_count');
      if (financialSummaryMap != null) _financialSummary = FinancialSummary.fromJson(financialSummaryMap);
      _employee = Employee.fromJson(jsonMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Company response. Error message - ${e.errorMessage}');
    } on MappingException {
      rethrow;
    }
  }

  String _initDateFormat(Map<String, dynamic> companyInfoMap) {
    var dateFormat = Sift().readStringFromMap(companyInfoMap, 'js_date_format');
    dateFormat = dateFormat.replaceAll("D", "d");
    dateFormat = dateFormat.replaceAll("Y", "y");
    return dateFormat;
  }

  List<Module> _initModules(List<String> moduleStrings) {
    List<Module> modules = [];
    moduleStrings.forEach((moduleString) {
      var module = initializeModuleFromString(moduleString);
      if (module != null) modules.add(module);
    });
    return modules;
  }

  String get id => _id;

  String get accountNumber => _accountNumber;

  String get name => _name;

  String get shortName => _shortName;

  String get commercialName => _commercialName;

  String get logoUrl => _logoUrl;

  String get dateFormat => _dateFormat;

  String get currency => _currency;

  List<Module> get modules => _modules;

  num get approvalCount => _approvalCount;

  FinancialSummary? get financialSummary => _financialSummary;

  Employee get employee => _employee;
}
