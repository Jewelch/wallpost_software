import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/constants/company_management_urls.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

class CompanyDetailsProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  CompanyDetailsProvider.initWith(this._currentUserProvider, this._companyRepository, this._networkAdapter);

  CompanyDetailsProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository.getInstance(),
        _networkAdapter = WPAPI();

  Future<void> getCompanyDetails(String companyId) async {
    var url = CompanyManagementUrls.getCompanyDetailsUrl(companyId);
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

  Future<void> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<void>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var company = Company.fromJson(responseMap);
      var employee = Employee.fromJson(responseMap);
      _companyRepository.selectCompanyAndEmployeeForUser(company, employee, _currentUserProvider.getCurrentUser());
      return null;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
