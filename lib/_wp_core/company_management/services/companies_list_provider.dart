import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/constants/company_management_urls.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/dashboard_management/entities/Dashboard.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

class CompaniesListProvider {
  final CurrentUserProvider _currentUserProvider;
  final CompanyRepository _companyRepository;
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  CompaniesListProvider.initWith(this._currentUserProvider, this._companyRepository, this._networkAdapter);

  CompaniesListProvider()
      : _currentUserProvider = CurrentUserProvider(),
        _companyRepository = CompanyRepository(),
        _networkAdapter = WPAPI();

  void reset() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<CompaniesGroup>?> get() async {
    var url = CompanyManagementUrls.getCompaniesUrl();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    var apiResponse = await _networkAdapter.get(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  List<CompaniesGroup>? _processResponse(APIResponse apiResponse) {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return [];

    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;

    return _readItemsFromResponse(responseMapList);
  }

  List<CompaniesGroup>? _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      List<Company> companies = <Company>[];
      List<CompaniesGroup> companiesData = <CompaniesGroup>[];

      for (var responseMap in responseMapList) {
        var companyListItem = CompaniesGroup.fromJson(responseMap);

        companies.addAll(companyListItem.companies);
        companiesData.add(companyListItem);
      }

      var currentUser = _currentUserProvider.getCurrentUser();
      _companyRepository.saveCompaniesForUser(companies, currentUser);
      return companiesData;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
