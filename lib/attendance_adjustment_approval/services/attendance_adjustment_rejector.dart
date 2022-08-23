import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';

class AttendanceAdjustmentRejector {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentRejector.initWith(this._networkAdapter);

  AttendanceAdjustmentRejector() : _networkAdapter = WPAPI();

  Future<void> reject(AttendanceAdjustmentApproval approval, {required String rejectionReason}) async {
    var url = AttendanceAdjustmentApprovalUrls.rejectUrl(approval.companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "attendanceAdjustmentRequest");
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
