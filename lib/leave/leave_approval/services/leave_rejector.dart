import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/leave_approval_urls.dart';

class LeaveRejector {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  LeaveRejector.initWith(this._networkAdapter);

  LeaveRejector() : _networkAdapter = WPAPI();

  Future<void> reject(String companyId, String leaveId, {required String rejectionReason}) async {
    var url = LeaveApprovalUrls.rejectUrl(companyId, leaveId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("comments", rejectionReason);
    apiRequest.addParameter("clearance_status", 0);
    apiRequest.addParameter("replaced_required", 1);
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
