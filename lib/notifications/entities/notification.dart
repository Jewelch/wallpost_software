import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import 'notification_route.dart';

abstract class Notification extends JSONInitializable {
  late String _notificationId;
  late String _objectReferenceId;
  late String _title;
  late String _message;
  late NotificationRoute _route;
  late bool _isRead;
  late DateTime _createdAt;

  Notification.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var dataMap = sift.readMapFromMap(jsonMap, 'data');
      _notificationId = '${sift.readNumberFromMap(jsonMap, 'notification_id')}';
      _objectReferenceId = sift.readStringFromMap(dataMap, 'reference_id');
      _title = sift.readStringFromMap(dataMap, 'title');
      _message = sift.readStringFromMap(dataMap, 'body');
      _route = NotificationRoute(sift.readStringFromMap(dataMap, 'route'));
      _isRead = sift.readStringFromMap(jsonMap, 'seen') == '1';
      _createdAt = sift.readDateFromMap(jsonMap, 'created_at', 'yyyy-MM-dd HH:mm:ss');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Notification response. Error message - ${e.errorMessage}');
    }
  }

  void markAsRead() {
    _isRead = true;
  }

  bool get isATaskNotification => _route.isATaskNotification();

  bool get isALeaveNotification => _route.isALeaveNotification();

  bool get isAHandoverNotification => _route.isAHandoverNotification();

  bool get isAnExpenseRequestNotification => _route.isAnExpenseRequestNotification();

  String get notificationId => _notificationId;

  String get objectReferenceId => _objectReferenceId;

  String get title => _title;

  String get message => _message;

  NotificationRoute get route => _route;

  bool get isRead => _isRead;

  DateTime get createdAt => _createdAt;
}
