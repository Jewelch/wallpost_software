import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/constants/company_management_urls.dart';
import 'package:wallpost/company_management/entities/employee_details.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';

class EmployeeDetailsProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  EmployeeDetailsProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  Future<EmployeeDetails> getDetails() async {
    var company = _selectedCompanyProvider.getSelectCompanyForCurrentUser();
    var url = CompanyManagementUrls.getEmployeeDetailsUrl(company.companyId);
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

  Future<EmployeeDetails> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<EmployeeDetails>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var employeeDetails = EmployeeDetails.fromJson(responseMap);
      return employeeDetails;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
