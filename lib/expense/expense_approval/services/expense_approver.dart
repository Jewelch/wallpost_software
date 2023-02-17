import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/expense_approval_urls.dart';

class ExpenseApprover {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  ExpenseApprover.initWith(this._networkAdapter);

  ExpenseApprover() : _networkAdapter = WPAPI();

  Future<void> approve(String companyId, String expenseId) async {
    var url = ExpenseApprovalUrls.approveUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "expenseRequest");
    apiRequest.addParameter("request_id", expenseId);

    await _executeRequest(apiRequest);
  }

  Future<void> massApprove(String companyId, List<String> expenseIds) async {
    var url = ExpenseApprovalUrls.approveUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "expenseRequest");
    apiRequest.addParameter("request_ids", expenseIds.join(','));

    await _executeRequest(apiRequest);
  }

  Future<void> _executeRequest(APIRequest apiRequest) async {
    _isLoading = true;
    try {
      await _networkAdapter.post(apiRequest);
      _isLoading = false;
      return null;
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  bool get isLoading => _isLoading;
}
