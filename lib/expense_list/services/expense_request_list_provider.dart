import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_list/constants/expense_list_urls.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';
import 'package:wallpost/expense_list/entities/expense_request_status_filter.dart';

class ExpenseRequestListProvider {
  final NetworkAdapter _networkAdapter;
  SelectedCompanyProvider _selectedCompanyProvider;
  late String _sessionId;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  bool isLoading = false;

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  ExpenseRequestListProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  ExpenseRequestListProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  // MARK: functions to get expense requests

  Future<List<ExpenseRequest>> getExpenseRequests(ExpenseRequestStatusFilter filter) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ExpenseListUrls.getEmployeeExpenses(companyId, _pageNumber, _perPage, filter);
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

  Future<List<ExpenseRequest>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<ExpenseRequest>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<ExpenseRequest> _readItemsFromResponse(List responseMapList) {
    try {
      var requests = <ExpenseRequest>[];
      for (var responseMap in responseMapList) {
        var item = ExpenseRequest.fromJson(responseMap);
        requests.add(item);
      }
      _updatePaginationRelatedData(requests.length);
      return requests;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  // MARK: functions to handle pagination

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

  bool get didReachListEnd => _didReachListEnd;
}
