import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

abstract class Notification extends JSONInitializable {
  String _notificationId;
  String _objectReferenceId;
  String _title;
  String _message;
  NotificationRoute _route;
  bool _isRead;
  DateTime _createdAt;

  Notification.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var dataMap = sift.readMapFromMap(jsonMap, 'data');
      _notificationId = '${sift.readNumberFromMap(jsonMap, 'notification_id')}';
      _objectReferenceId = sift.readStringFromMap(dataMap, 'reference_id');
      _title = sift.readStringFromMap(dataMap, 'title');
      _message = sift.readStringFromMap(dataMap, 'body');
      _route = NotificationRoute(sift.readStringFromMap(dataMap, 'route'));
      _isRead = sift.readStringFromMap(jsonMap, 'seen') == '1';
      _createdAt =
          sift.readDateFromMap(jsonMap, 'created_at', 'yyyy-MM-dd HH:mm:ss');
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast Notification response. Error message - ${e.errorMessage}');
    }
  }

  bool get isATaskNotification => _route.isATaskNotification();

  bool get isALeaveNotification => _route.isALeaveNotification();

  bool get isAHandoverNotification => _route.isAHandoverNotification();

  bool get isAnExpenseRequestNotification =>
      _route.isAnExpenseRequestNotification();

  String get notificationId => _notificationId;

  String get objectReferenceId => _objectReferenceId;

  String get title => _title;

  String get message => _message;

  NotificationRoute get route => _route;

  bool get isRead => _isRead;

  set isRead(bool value) {
    _isRead = value;
  }

  DateTime get createdAt => _createdAt;
}

class NotificationRoute {
  final String route;

  NotificationRoute(this.route);

  bool isATaskNotification() {
    return route.toLowerCase().contains('task');
  }

  bool isALeaveNotification() {
    return route.toLowerCase().contains('leave');
  }

  bool isAHandoverNotification() {
    return route.toLowerCase().contains('handover');
  }

  bool isAnExpenseRequestNotification() {
    return route.toLowerCase().contains('expense');
  }
}
