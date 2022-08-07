import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

class CompanyListItem extends JSONInitializable {
  late String _id;
  late String _name;
  late String _logoUrl;
  late num _approvalCount;
  FinancialSummary? _financialSummary;

  CompanyListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var financialSummaryMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'financial_summary', null);
      _id = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _name = sift.readStringFromMap(jsonMap, 'company_name');
      _logoUrl = sift.readStringFromMap(jsonMap, 'company_logo');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approval_count');
      if (financialSummaryMap != null) _financialSummary = FinancialSummary.fromJson(financialSummaryMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast CompanyListItem response. Error message - ${e.errorMessage}');
    }
  }

  FinancialSummary? get financialSummary => _financialSummary;

  num get approvalCount => _approvalCount;

  String get logoUrl => _logoUrl;

  String get name => _name;

  String get id => _id;
}
