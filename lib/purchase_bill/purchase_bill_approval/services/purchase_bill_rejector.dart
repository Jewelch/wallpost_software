import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/constants/purchase_bill_approval_urls.dart';

class PurchaseBillRejector {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  PurchaseBillRejector.initWith(this._networkAdapter);

  PurchaseBillRejector() : _networkAdapter = WPAPI();

  Future<void> reject(String companyId, String billId, {required String rejectionReason}) async {
    var url = PurchaseBillApprovalUrls.rejectUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "billRequest");
    apiRequest.addParameter("request_id", billId);
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

  Future<void> massReject(String companyId, List<String> billIds, {required String rejectionReason}) async {
    var url = PurchaseBillApprovalUrls.rejectUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "billRequest");
    apiRequest.addParameter("request_ids", billIds.join(','));
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
