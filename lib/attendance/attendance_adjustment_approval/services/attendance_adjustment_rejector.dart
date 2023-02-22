import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';

class AttendanceAdjustmentRejector {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentRejector.initWith(this._networkAdapter);

  AttendanceAdjustmentRejector() : _networkAdapter = WPAPI();

  Future<void> reject(
    String companyId,
    String attendanceAdjustmentId, {
    required String rejectionReason,
  }) async {
    var url = AttendanceAdjustmentApprovalUrls.rejectUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "attendanceAdjustmentRequest");
    apiRequest.addParameter("request_id", attendanceAdjustmentId);
    apiRequest.addParameter("reason", rejectionReason);

    await _executeRequest(apiRequest);
  }

  Future<void> massReject(
      String companyId,
      List<String> attendanceAdjustmentIds, {
        required String rejectionReason,
      }) async {
    var url = AttendanceAdjustmentApprovalUrls.rejectUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "attendanceAdjustmentRequest");
    apiRequest.addParameter("request_id", attendanceAdjustmentIds.join(','));
    apiRequest.addParameter("reason", rejectionReason);

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
