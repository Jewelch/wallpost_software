import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/notifications/entities/company_unread_notifications_count.dart';

class UnreadNotificationsCount extends JSONInitializable {
  List<CompanyUnreadNotificationsCount> _allCompaniesUnreadNotificationsCount = [];
  late num _totalUnreadNotificationsCount;

  UnreadNotificationsCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var companiesMap = sift.readMapFromMap(jsonMap, 'companies_count');
      _allCompaniesUnreadNotificationsCount = _readCompanyWiseNotificationCount(companiesMap);
      _totalUnreadNotificationsCount = sift.readNumberFromMap(jsonMap, 'total_count');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast UnreadNotificationCount response. Error message - ${e.errorMessage}');
    }
  }

  List<CompanyUnreadNotificationsCount> _readCompanyWiseNotificationCount(Map<String, dynamic> companiesMap) {
    List<CompanyUnreadNotificationsCount> companyWiseCounts = [];
    companiesMap.forEach((companyId, companyCountMap) {
      companyCountMap.putIfAbsent('company_id', () => companyId);
      var companyNotificationCount = CompanyUnreadNotificationsCount.fromJson(companyCountMap);
      _allCompaniesUnreadNotificationsCount.add(companyNotificationCount);
    });
    return companyWiseCounts;
  }

  num get totalUnreadNotifications => _totalUnreadNotificationsCount;

  List<CompanyUnreadNotificationsCount> get allCompaniesUnreadNotificationsCount =>
      _allCompaniesUnreadNotificationsCount;
}
