import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/leave_approval_urls.dart';

class LeaveApprover {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  LeaveApprover.initWith(this._networkAdapter);

  LeaveApprover() : _networkAdapter = WPAPI();

  Future<void> approve(String companyId, String leaveId) async {
    var url = LeaveApprovalUrls.approveUrl(companyId, leaveId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("comments", "");
    apiRequest.addParameter("replaced_required", "1");
    apiRequest.addParameter("replaced_by", []);
    apiRequest.addParameter("clearance_status", 1);
    apiRequest.addParameter("handover_status", 1);
    apiRequest.addParameter("replaced_by_others", "");

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
