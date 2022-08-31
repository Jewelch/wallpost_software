import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';

class AttendanceAdjustmentApprover {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentApprover.initWith(this._networkAdapter);

  AttendanceAdjustmentApprover() : _networkAdapter = WPAPI();

  Future<void> approve(String companyId, String attendanceAdjustmentId) async {
    var url = AttendanceAdjustmentApprovalUrls.approveUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "attendanceAdjustmentRequest");
    apiRequest.addParameter("request_id", attendanceAdjustmentId);
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
