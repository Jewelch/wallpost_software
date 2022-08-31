import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/expense/expense_detail/constants/expense_detail_urls.dart';

import '../../expense__core/entities/expense_request.dart';

class ExpenseDetailProvider {
  final String _companyId;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool isLoading = false;

  void reset() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  ExpenseDetailProvider(this._companyId) : _networkAdapter = WPAPI();

  ExpenseDetailProvider.initWith(this._companyId, this._networkAdapter);

  // MARK: functions to get expense requests

  Future<ExpenseRequest> get(String expenseId) async {
    var url = ExpenseDetailUrls.getExpenseDetailUrl(_companyId, expenseId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
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

  Future<ExpenseRequest> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<ExpenseRequest>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    var item = ExpenseRequest.fromJson(responseMap);
    return item;
  }
}
