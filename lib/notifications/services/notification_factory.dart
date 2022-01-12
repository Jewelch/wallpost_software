import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/notifications/entities/expense_request_notification.dart';
import 'package:wallpost/notifications/entities/handover_notification.dart';
import 'package:wallpost/notifications/entities/leave_notification.dart';
import 'package:wallpost/notifications/entities/notification.dart';
import 'package:wallpost/notifications/entities/task_notification.dart';

class NotificationFactory {
  static Notification? createNotification(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      var dataMap = sift.readMapFromMap(jsonMap, 'data');
      var route = NotificationRoute(sift.readStringFromMap(dataMap, 'route'));

      if (route.isATaskNotification()) return TaskNotification.fromJson(jsonMap);

      if (route.isALeaveNotification()) return LeaveNotification.fromJson(jsonMap);

      if (route.isAHandoverNotification()) return HandoverNotification.fromJson(jsonMap);

      if (route.isAnExpenseRequestNotification()) return ExpenseRequestNotification.fromJson(jsonMap);

      return null;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Notification response. Error message - ${e.errorMessage}');
    }
  }
}
