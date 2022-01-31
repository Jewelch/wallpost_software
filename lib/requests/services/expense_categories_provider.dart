import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/requests/constants/requests_urls.dart';
import 'package:wallpost/requests/entities/expense_category.dart';

class ExpenseCategoriesProvider {
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  ExpenseCategoriesProvider() : _networkAdapter = WPAPI();

  ExpenseCategoriesProvider.initWith(this._networkAdapter);

  Future<List<ExpenseCategory>> get(String companyId) async {
    var url = RequestsUrls.getExpenseRequestUrl(companyId);
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    var apiResponse = await _networkAdapter.get(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  List<ExpenseCategory> _processResponse(APIResponse apiResponse) {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return [];

    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! List<Map<String, dynamic>>)
      throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<ExpenseCategory> _readItemsFromResponse(
      List<Map<String, dynamic>> responseMapList) {
    try {
      var categories = <ExpenseCategory>[];
      var eligibleItemsList = responseMapList
          .where((element) => element['disable']! == false)
          .toList();
      for (var responseMap in eligibleItemsList) {
        var item = ExpenseCategory.fromJson(responseMap);
        categories.add(item);
      }
      return categories;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
