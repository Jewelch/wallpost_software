import 'package:sift/sift.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_convertible.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';
import 'company_group.dart';
import 'company_list_item.dart';
import 'financial_summary.dart';

class CompanyList extends JSONInitializable implements JSONConvertible {
  late FinancialSummary? _financialSummary;
  late List<CompanyGroup> _groups;
  late List<CompanyListItem> _companies;

  CompanyList(this._financialSummary, this._groups, this._companies) : super.fromJson({});

  CompanyList.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var groupMapList = sift.readMapListFromMapWithDefaultValue(jsonMap, "groups", [])!;
      var companyMapList = sift.readMapListFromMap(jsonMap, "companies");
      _financialSummary = _readOverallFinancialSummary(groupMapList);
      _groups = _readCompaniesGroups(groupMapList);
      _companies = _readCompanies(companyMapList);
    } on SiftException catch (e) {
      print(e.errorMessage);
      throw MappingException('Failed to cast Dashboard response. Error message - ${e.errorMessage}');
    }
  }

  FinancialSummary? _readOverallFinancialSummary(List<Map<String, dynamic>> groupMapList) {
    if (groupMapList.isEmpty) return null;

    var sift = Sift();
    var allCompaniesGroupMap = sift.readMapFromList(groupMapList, 0);
    var overallFinancialSummaryMap = sift.readMapFromMap(allCompaniesGroupMap, "group_summary");
    return FinancialSummary.fromJson(overallFinancialSummaryMap);
  }

  List<CompanyGroup> _readCompaniesGroups(List<Map<String, dynamic>> groupMapList) {
    List<CompanyGroup> groups = [];
    for (int i = 1; i < groupMapList.length; i++) {
      groups.add(CompanyGroup.fromJson(groupMapList[i]));
    }
    return groups;
  }

  List<CompanyListItem> _readCompanies(List<Map<String, dynamic>> companyMapList) {
    List<CompanyListItem> companies = [];
    companyMapList.forEach((companyMap) {
      companies.add(CompanyListItem.fromJson(companyMap));
    });
    return companies;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'financial_summary': _financialSummary?.toJson(),
      'groups': _convertGroupsToMap(),
      'companies': _convertCompaniesToMap(),
    };
    return jsonMap;
  }

  List<Map<String, dynamic>> _convertGroupsToMap() {
    List<Map<String, dynamic>> groupsMapList = [];
    _groups.forEach((group) {
      groupsMapList.add(group.toJson());
    });
    return groupsMapList;
  }

  List<Map<String, dynamic>> _convertCompaniesToMap() {
    List<Map<String, dynamic>> companiesMapList = [];
    _companies.forEach((company) {
      companiesMapList.add(company.toJson());
    });
    return companiesMapList;
  }

  List<CompanyListItem> get companies => _companies;

  List<CompanyGroup> get groups => _groups;

  FinancialSummary? get financialSummary => _financialSummary;

}
