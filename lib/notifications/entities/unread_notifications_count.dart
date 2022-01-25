import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/notifications/entities/selected_company_unread_notifications_count.dart';

class UnreadNotificationsCount extends JSONInitializable {

  List<SelectedCompanyUnreadNotificationsCount> _allCompaniesUnreadNotificationsCount = [];
  late num _totalUnreadNotificationsCount;
  late SelectedCompanyUnreadNotificationsCount _selectedCompanyUnreadNotificationsCount;

  UnreadNotificationsCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var companiesMap = sift.readMapFromMap(jsonMap, 'companies_count');
      companiesMap.forEach((companyId, v) => _allCompaniesUnreadNotificationsCount.add(SelectedCompanyUnreadNotificationsCount.fromJson(readUnreadNotificationsCountForSelectedCompany(jsonMap,companyId))));
       _totalUnreadNotificationsCount = sift.readNumberFromMap(jsonMap, 'total_count');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast UnreadNotificationCount response. Error message - ${e.errorMessage}');
    }
  }

  Map<String, dynamic> readUnreadNotificationsCountForSelectedCompany(Map<String, dynamic> responseMap,Object selectedCompanyId) {
    var sift = Sift();

    try {
      var companiesCountMap = sift.readMapFromMap(responseMap, 'companies_count');
      var selectedCompanyCountMap = sift.readMapFromMap(companiesCountMap, selectedCompanyId.toString());
      selectedCompanyCountMap.putIfAbsent('selected_company_id',() => selectedCompanyId);
      return selectedCompanyCountMap;
    } on SiftException catch (e) {
      throw InvalidResponseException();
    }
  }

  num get totalUnreadNotifications => _totalUnreadNotificationsCount;
  List<SelectedCompanyUnreadNotificationsCount> get allCompaniesUnreadNotificationsCount => _allCompaniesUnreadNotificationsCount;
}