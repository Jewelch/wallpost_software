import 'package:sift/sift.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class CompanyGroup extends JSONInitializable {
  late num _groupId;
  late String _name;
  late List<String> _companyIds;
  late FinancialSummary? _financialSummary;

  CompanyGroup.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();

    try {
      var financialSummaryMap = sift.readMapFromMapWithDefaultValue(jsonMap, "group_summary", null);
      _groupId = sift.readNumberFromMap(jsonMap, 'group_id');
      _name = sift.readStringFromMap(jsonMap, 'name');
      _companyIds = sift.readStringListFromMap(jsonMap, "group_companies");
      if (financialSummaryMap != null) {
        var currency = sift.readStringFromMap(jsonMap, "default_currency");
        financialSummaryMap.putIfAbsent("currency", () => currency);
        _financialSummary = FinancialSummary.fromJson(financialSummaryMap);
      }
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Dashboard response. Error message - ${e.errorMessage}');
    }
  }

  num get groupId => _groupId;

  String get name => _name;

  List<String> get companyIds => _companyIds;

  FinancialSummary? get financialSummary => _financialSummary;
}
