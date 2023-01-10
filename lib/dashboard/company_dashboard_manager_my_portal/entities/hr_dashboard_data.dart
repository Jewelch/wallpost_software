import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class HRDashboardData extends JSONInitializable {
  late final String _activeStaff;
  late final String _staffOnLeaveToday;
  late final String _recruitment;
  late final String _documentsExpired;

  HRDashboardData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _activeStaff = sift.readStringFromMap(jsonMap, "active_staff");
      _staffOnLeaveToday = sift.readStringFromMap(jsonMap, "staff_on_leave");
      _recruitment = sift.readStringFromMap(jsonMap, "recruitment");
      _documentsExpired = sift.readStringFromMap(jsonMap, "documents_expired");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast HRDashboardData response. Error message - ${e.errorMessage}');
    }
  }

  bool hasAnyActiveStaff() {
    return _activeStaff != "0";
  }

  bool isAnyStaffOnLeave() {
    return _staffOnLeaveToday != "0";
  }

  bool isRecruitmentPending() {
    return _recruitment != "0";
  }

  bool areAnyDocumentsExpired() {
    return _documentsExpired != "0";
  }

  String get activeStaff => _activeStaff;

  String get recruitment => _recruitment;

  String get staffOnLeaveToday => _staffOnLeaveToday;

  String get documentsExpired => _documentsExpired;
}
