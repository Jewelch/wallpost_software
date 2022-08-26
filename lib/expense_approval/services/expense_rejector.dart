import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/expense_approval_urls.dart';
import '../entities/expense_approval.dart';

class ExpenseRejector {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  ExpenseRejector.initWith(this._networkAdapter);

  ExpenseRejector() : _networkAdapter = WPAPI();

  Future<void> reject(ExpenseApproval approval, {required String rejectionReason}) async {
    var url = ExpenseApprovalUrls.rejectUrl(approval.companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "expenseRequest");
    apiRequest.addParameter("request_id", approval.id);
    apiRequest.addParameter("reason", rejectionReason);
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
