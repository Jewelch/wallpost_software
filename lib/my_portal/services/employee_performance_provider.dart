import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/my_portal/constants/performance_urls.dart';
import 'package:wallpost/my_portal/entities/employee_performance.dart';

class EmployeePerformanceProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  EmployeePerformanceProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  EmployeePerformanceProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  Future<EmployeePerformance> getPerformance(int year) async {
    var company = _selectedCompanyProvider.getSelectCompanyForCurrentUser();
    var url = PerformanceUrls.employeePerformanceUrl(company.companyId, '$year');
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

  Future<EmployeePerformance> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<EmployeePerformance>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var employeePerformance = EmployeePerformance.fromJson(responseMap);
      return employeePerformance;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
