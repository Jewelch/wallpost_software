import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class CompanyUnreadNotificationsCount extends JSONInitializable {
  late String _companyId;
  late num _unreadTaskNotificationsCount;
  late num _unreadMyPortalNotificationsCount;

  CompanyUnreadNotificationsCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var modulesMap = sift.readMapFromMap(jsonMap, 'modules');
      _companyId = sift.readStringFromMap(jsonMap, 'company_id');
      _unreadTaskNotificationsCount = sift.readNumberFromMap(modulesMap, 'TASK');
      _unreadMyPortalNotificationsCount = sift.readNumberFromMap(modulesMap, 'MYPORTAL');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast UnreadNotificationCount response. Error message - ${e.errorMessage}');
    }
  }

  String get companyId => _companyId;

  num get totalUnreadNotificationsCount => _unreadTaskNotificationsCount + _unreadMyPortalNotificationsCount;
}
