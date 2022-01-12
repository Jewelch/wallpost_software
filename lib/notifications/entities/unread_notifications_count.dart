import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class UnreadNotificationsCount extends JSONInitializable {
  late num _unreadTaskNotificationsCount;
  late num _unreadMyPortalNotificationsCount;

  UnreadNotificationsCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var modulesMap = sift.readMapFromMap(jsonMap, 'modules');
      _unreadTaskNotificationsCount = sift.readNumberFromMap(modulesMap, 'TASK');
      _unreadMyPortalNotificationsCount = sift.readNumberFromMap(modulesMap, 'MYPORTAL');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast UnreadNotificationCount response. Error message - ${e.errorMessage}');
    }
  }

  num get totalUnreadNotifications => _unreadTaskNotificationsCount + _unreadMyPortalNotificationsCount;
}
