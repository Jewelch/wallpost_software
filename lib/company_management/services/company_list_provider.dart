import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/constants/company_management_urls.dart';
import 'package:wallpost/company_management/entities/company.dart';

class CompanyListProvider {
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 0;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  CompanyListProvider.initWith(this._networkAdapter);

  void reset() {
    _pageNumber = 0;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<Company>> get() async {
    var url = CompanyManagementUrls.getCompaniesUrl('$_pageNumber', '$_perPage');
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    var apiResponse = await _networkAdapter.get(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  List<Company> _processResponse(APIResponse apiResponse) {
    if (apiResponse.apiRequest.requestId != _sessionId) {
      return []; //returning empty list if the response is from another session
    }

    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<Company> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var companyList = <Company>[];
      for (var responseMap in responseMapList) {
        var company = Company.fromJson(responseMap);
        companyList.add(company);
      }
      _updatePaginationRelatedData(companyList.length);
      return companyList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }
}
