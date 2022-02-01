import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/notifications/entities/company_unread_notifications_count.dart';

class UnreadNotificationsCount extends JSONInitializable {
  List<CompanyUnreadNotificationsCount> _allCompaniesUnreadNotificationsCount = [];

  UnreadNotificationsCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var companiesMap = sift.readMapFromMap(jsonMap, 'companies_count');
      _allCompaniesUnreadNotificationsCount = _readCompanyWiseNotificationCount(companiesMap);
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

  //MARK: Getters

  List<CompanyUnreadNotificationsCount> get allCompaniesUnreadNotificationsCount =>
      _allCompaniesUnreadNotificationsCount;

  int getTotalUnreadNotificationCount() {
    var count = 0;
    for (CompanyUnreadNotificationsCount companyCount in _allCompaniesUnreadNotificationsCount) {
      count += companyCount.totalUnreadNotificationsCount.toInt();
    }
    return count;
  }
}
