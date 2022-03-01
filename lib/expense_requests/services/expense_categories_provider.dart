import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/expense_requests/constants/expense_requests_urls.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';

class ExpenseCategoriesProvider {
  final NetworkAdapter _networkAdapter;
  late String _sessionId;

  bool isLoading = false;

  ExpenseCategoriesProvider() : _networkAdapter = WPAPI();

  ExpenseCategoriesProvider.initWith(this._networkAdapter);

  Future<List<ExpenseCategory>> get(String companyId) async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = ExpenseRequestsUrls.getExpenseCategoriesUrl(companyId);
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return await _processResponse(apiResponse);
    } on WPException {
      isLoading = false;
      rethrow;
    }
  }

  Future<List<ExpenseCategory>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<List<ExpenseCategory>>().future;

    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<ExpenseCategory> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var categories = <ExpenseCategory>[];
      for (var responseMap in responseMapList) {
        var item = ExpenseCategory.fromJson(responseMap);
        categories.add(item);
      }
      return categories;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
