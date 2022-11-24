import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class PushNotification extends JSONInitializable {
  late final String route;
  late final String companyId;
  late final String objectId;
  late final String title;

  PushNotification.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var notificationMap = sift.readMapFromMapWithDefaultValue(jsonMap, "notification", {})!;
      route = sift.readStringFromMap(jsonMap, "route");
      companyId = sift.readStringFromMap(jsonMap, "company_id");
      objectId = sift.readStringFromMap(jsonMap, "reference_id");
      title = sift.readStringFromMapWithDefaultValue(notificationMap, "title", "Received Notification")!;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast PushNotification response. Error message - ${e.errorMessage}');
    }
  }

  bool isExpenseApprovalRequiredNotification() {
    return route == "myportal://myportal/expense-approval-required";
  }

  bool isExpenseApprovedNotification() {
    return route == "myportal://myportal/expense-approved";
  }

  bool isExpenseRejectedNotification() {
    return route == "myportal://myportal/expense-rejected";
  }

  bool isLeaveApprovalRequiredNotification() {
    return route == "myportal://myportal/leave-approval-required";
  }

  bool isLeaveApprovedNotification() {
    return route == "myportal://myportal/leave-approved";
  }

  bool isLeaveRejectedNotification() {
    return route == "myportal://myportal/leave-rejected";
  }

  bool isAttendanceAdjustmentApprovalRequiredNotification() {
    return route == "myportal://myportal/attendance-adjustment-approval-required";
  }

  bool isAttendanceAdjustmentApprovedNotification() {
    return route == "myportal://myportal/attendance-adjustment-approved";
  }

  bool isAttendanceAdjustmentRejectedNotification() {
    return route == "myportal://myportal/attendance-adjustment-rejected";
  }
}
