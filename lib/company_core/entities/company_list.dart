import 'package:sift/sift.dart';
import 'package:wallpost/company_core/entities/company.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';
import 'company.dart';
import 'company_group.dart';
import 'financial_summary.dart';

class CompanyList extends JSONInitializable {
  late FinancialSummary? _financialSummary;
  late List<CompanyGroup> _groups;
  late List<Company> _companies;

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
      throw MappingException('Failed to cast Dashboard response. Error message - ${e.errorMessage}');
    }
  }

  FinancialSummary? _readOverallFinancialSummary(List<Map<String, dynamic>> groupMapList) {
    if (groupMapList.isEmpty) return null;

    var sift = Sift();
    var allCompaniesGroupMap = sift.readMapFromList(groupMapList, 0);
    var overallFinancialSummaryMap = sift.readMapFromMap(allCompaniesGroupMap, "group_summary");
    var currency = sift.readStringFromMap(allCompaniesGroupMap, "default_currency");
    overallFinancialSummaryMap.putIfAbsent("currency", () => currency);
    return FinancialSummary.fromJson(overallFinancialSummaryMap);
  }

  List<CompanyGroup> _readCompaniesGroups(List<Map<String, dynamic>> groupMapList) {
    List<CompanyGroup> groups = [];
    for (int i = 1; i < groupMapList.length; i++) {
      groups.add(CompanyGroup.fromJson(groupMapList[i]));
    }
    return groups;
  }

  List<Company> _readCompanies(List<Map<String, dynamic>> companyMapList) {
    List<Company> companies = [];
    companyMapList.forEach((companyMap) {
      companies.add(Company.fromJson(companyMap));
    });
    return companies;
  }

  bool shouldShowFinancialData() {
    //checking if at least one company has financial data
    //if no company has financial data, then hide the financial summary
    if (companies.where((c) => c.financialSummary != null).toList().length > 0) {
      return true;
    } else {
      return false;
    }
  }

  List<Company> get companies => _companies;

  List<CompanyGroup> get groups => _groups;

  FinancialSummary? get financialSummary => _financialSummary;

  List<Map<String, dynamic>> omap() {
    return [
      {
        "company_info": {
          "company_id": 13,
          "account_no": 123123,
          "company_name": "Smart Management - Qatar",
          "short_name": "Smart Management - Qatar",
          "commercial_name": "Smart Management - Qatar",
          "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
          "js_date_format": "yyyy-mm-dd",
          "currency": "USD",
          "packages": ["hr", "task", "timesheet"],
          "is_trial": true,
          "approval_count": 8
        },
        "employee": {
          "employment_id": "gEBrqqLflxXRNQT",
          "name": "Obaid Mohamed",
          "designation": "IOS Developer",
          "email_id_office": "mahmed@wallpostsoftware.com",
          "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
          "employment_id_v1": 2123,
          "line_manager": "Ishaque Sethikunhi Ameen",
          "Roles": ["task_line_manager"],
          "request_items": [
            {
              "display_name": "Disciplinary Action",
              "name": "disciplinary_request",
              "sub_module": "disciplinary_action",
              "visibility": true
            },
            {
              "display_name": "Employment Certificate",
              "name": "time_off_request",
              "sub_module": "time_off",
              "visibility": true
            },
            {
              "display_name": "Expense Request",
              "name": "expense_request",
              "sub_module": "expense_request",
              "visibility": true
            }
          ]
        },
        "financial_summary": {
          "currency": "BGN",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "9.9M",
          "receivableOverdue": "32.3K",
          "payableOverdue": "67.3K",
          "profitLoss": "14.7K",
          "profitLossPerc": "51.854325587935"
        }
      },
      {
        "company_info": {
          "company_id": 13,
          "account_no": 123123,
          "company_name": "Smart Management - Qatar",
          "short_name": "Smart Management - Qatar",
          "commercial_name": "Smart Management - Qatar",
          "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
          "js_date_format": "yyyy-mm-dd",
          "currency": "USD",
          "packages": ["hr", "task", "timesheet"],
          "is_trial": true,
          "approval_count": 8
        },
        "employee": {
          "employment_id": "gEBrqqLflxXRNQT",
          "name": "Obaid Mohamed",
          "designation": "IOS Developer",
          "email_id_office": "mahmed@wallpostsoftware.com",
          "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
          "employment_id_v1": 2123,
          "line_manager": "Ishaque Sethikunhi Ameen",
          "Roles": ["task_line_manager"],
          "request_items": [
            {
              "display_name": "Disciplinary Action",
              "name": "disciplinary_request",
              "sub_module": "disciplinary_action",
              "visibility": true
            },
            {
              "display_name": "Employment Certificate",
              "name": "time_off_request",
              "sub_module": "time_off",
              "visibility": true
            },
            {
              "display_name": "Expense Request",
              "name": "expense_request",
              "sub_module": "expense_request",
              "visibility": true
            }
          ]
        },
        "financial_summary": null,
      }
    ];
  }

  List<Map<String, dynamic>> domap() {
    return [
      {
        "company_info": {
          "company_id": 28,
          "account_no": 105424,
          "company_name": "AB Real Estate",
          "short_name": "AB Real Estate",
          "commercial_name": "AB Real Estate",
          "company_logo": "https://s3.amazonaws.com/wallpostsoftware/105424/28/DOC7309_WallPost.png",
          "js_date_format": "yyyy-mm-dd",
          "currency": "USD",
          "packages": ["hr", "task", "timesheet"],
          "is_trial": true,
          "approval_count": 8
        },
        "employee": {
          "employment_id": "oToeYfgA91Fhn5h",
          "name": "Millan Cooper",
          "designation": "General Manager",
          "email_id_office": "smitit2019+105424_1348@gmail.com",
          "image": "DOC_32d07dd5-85e8-4291-bf8d-4abdf06d98d5.jpg",
          "employment_id_v1": 1348,
          "line_manager": null,
          "Roles": ["general_manager", "owner", "task_line_manager"],
          "request_items": [
            {
              "display_name": "Disciplinary Action",
              "name": "disciplinary_request",
              "sub_module": "disciplinary_action",
              "visibility": true
            },
            {
              "display_name": "Employment Certificate",
              "name": "time_off_request",
              "sub_module": "time_off",
              "visibility": true
            },
            {
              "display_name": "Expense Request",
              "name": "expense_request",
              "sub_module": "expense_request",
              "visibility": true
            }
          ]
        },
        "financial_summary": {
          "currency": "BGN",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "9.9M",
          "receivableOverdue": "32.3K",
          "payableOverdue": "67.3K",
          "profitLoss": "14.7K",
          "profitLossPerc": "51.854325587935"
        }
      },
      {
        "company_info": {
          "company_id": 3,
          "account_no": 105424,
          "company_name": "Advisory Co",
          "short_name": "Advisory Co",
          "commercial_name": "Advisory Co",
          "company_logo": "https://s3.amazonaws.com/wallpostsoftware/105424/3/DOC46545_logo.png",
          "js_date_format": "yyyy-mm-dd",
          "currency": "USD",
          "packages": ["hr", "task", "timesheet"],
          "is_trial": true,
          "approval_count": 8
        },
        "employee": {
          "employment_id": "vGjP2MsUY3Eh2UU",
          "name": "Millan Cooper Wallpost",
          "designation": "Tech Lead",
          "email_id_office": "huigv@wallpostdev.com",
          "image": "DOC4542_download.jpg",
          "employment_id_v1": 4,
          "line_manager": null,
          "Roles": ["general_manager", "owner", "task_line_manager"],
          "request_items": [
            {
              "display_name": "Disciplinary Action",
              "name": "disciplinary_request",
              "sub_module": "disciplinary_action",
              "visibility": true
            },
            {
              "display_name": "Employment Certificate",
              "name": "time_off_request",
              "sub_module": "time_off",
              "visibility": true
            },
            {
              "display_name": "Expense Request",
              "name": "expense_request",
              "sub_module": "expense_request",
              "visibility": true
            }
          ]
        },
        "financial_summary": null,
      }
    ];
  }
}
