import 'dart:async';

import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/constants/company_management_urls.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

class CompanyListProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  CompanyListProvider.initWith(this._currentUserProvider, this._companyRepository, this._networkAdapter);

  CompanyListProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository.getInstance(),
        _networkAdapter = WPAPI();

  Future<CompanyList> get() async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = CompanyManagementUrls.getCompaniesUrl();
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

  Future<CompanyList> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<CompanyList>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var groupDashboard = CompanyList.fromJson(responseMap);
      var currentUser = _currentUserProvider.getCurrentUser();
      _companyRepository.saveCompanyListForUser(groupDashboard, currentUser);
      return groupDashboard;
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }
}
