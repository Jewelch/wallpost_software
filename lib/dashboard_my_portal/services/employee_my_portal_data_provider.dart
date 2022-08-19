import 'dart:async';

import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/dashboard_my_portal/constants/my_portal_dashboard_urls.dart';

import '../entities/employee_my_portal_data.dart';

class EmployeeMyPortalDataProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  EmployeeMyPortalDataProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  EmployeeMyPortalDataProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<EmployeeMyPortalData> get() async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = MyPortalDashboardUrls.employeeMyPortalDataUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<EmployeeMyPortalData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<EmployeeMyPortalData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    //TODO: uncomment the next line and remove hardcoded map
    // var responseMap = apiResponse.data as Map<String, dynamic>;

    var responseMap = {
      "aggregated_approvals": [
        {
          "comapnyId": 13,
          "companyName": "Smart Management IT Solutions",
          "approvalType": "Leave Request",
          "module": "hr",
          "moduleId": "hr",
          "moduleColor": "#f2b33d",
          "approvalCount": 8
        },
        {
          "comapnyId": 3,
          "companyName": "Smart Management IT Solutions ",
          "approvalType": "Expense Request",
          "module": "hr",
          "moduleId": "hr",
          "moduleColor": "#f2b33d",
          "approvalCount": 4
        }
      ],
      "financial_summary": {
        "currency": "BGN",
        "actual_revenue_display": "0",
        "overall_revenue": 0,
        "cashAvailability": "9.9M",
        "receivableOverdue": "32.3K",
        "payableOverdue": "67.3K",
        "profitLoss": "14.7K",
        "profitLossPerc": "51.854325587935"
      },
      "ytd_performance": 80.5,
      "current_month_performance": 36.5,
      "current_month_attendance_percentage": 73.5
    };
    try {
      return EmployeeMyPortalData.fromJson(responseMap);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }
}
