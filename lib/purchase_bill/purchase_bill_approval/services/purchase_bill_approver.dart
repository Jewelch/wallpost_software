import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/constants/purchase_bill_approval_urls.dart';

class PurchaseBillApproval {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  PurchaseBillApproval.initWith(this._networkAdapter);

  PurchaseBillApproval() : _networkAdapter = WPAPI();

  Future<void> approve(String companyId, String billId) async {
    var url = PurchaseBillApprovalUrls.approveUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "billRequest");
    apiRequest.addParameter("request_id", billId);

    await _executeRequest(apiRequest);
  }

  Future<void> massApprove(String companyId, List<String> billIds) async {
    var url = PurchaseBillApprovalUrls.approveUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "billRequest");
    apiRequest.addParameter("request_ids", billIds.join(','));

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
