import 'package:wallpost/_wp_core/company_management/constants/company_management_urls.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/wpapi/wp_api.dart';

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

  Future<List<CompanyListItem>> get() async {
    var url = CompanyManagementUrls.getCompaniesUrl();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    var apiResponse = await _networkAdapter.get(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  List<CompanyListItem> _processResponse(APIResponse apiResponse) {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return [];

    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! List<Map<String, Object>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<CompanyListItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var companies = <CompanyListItem>[];
      for (var responseMap in responseMapList) {
        var companyListItem = CompanyListItem.fromJson(responseMap);
        companies.add(companyListItem);
      }
      var currentUser = _currentUserProvider.getCurrentUser();
      _companyRepository.saveCompaniesForUser(companies, currentUser);
      return companies;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
