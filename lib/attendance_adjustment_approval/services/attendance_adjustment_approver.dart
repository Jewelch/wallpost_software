import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';

class AttendanceAdjustmentApprover {
  final NetworkAdapter _networkAdapter;
  bool _isLoading = false;
  late String _sessionId;

  AttendanceAdjustmentApprover.initWith(this._networkAdapter);

  AttendanceAdjustmentApprover() : _networkAdapter = WPAPI();

  Future<void> approve(AttendanceAdjustmentApproval approval) async {
    var url = AttendanceAdjustmentApprovalUrls.approveUrl(approval.companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter("app_type", "attendanceAdjustmentRequest");
    apiRequest.addParameter("request_id", approval.id);
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
