// @dart=2.9

import 'dart:async';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';
import 'package:wallpost/notifications/entities/unread_notifications_count.dart';

class UnreadNotificationsCountProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  UnreadNotificationsCountProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  UnreadNotificationsCountProvider()
      : this._selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<UnreadNotificationsCount> getCount() async {
    var url = NotificationUrls.unreadNotificationsCountUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<UnreadNotificationsCount> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<UnreadNotificationsCount>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    var selectCompanyCountsMap = readUnreadNotificationsCountForSelectedCompany(responseMap);
    try {
      var unreadNotificationCount = UnreadNotificationsCount.fromJson(selectCompanyCountsMap);
      return unreadNotificationCount;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  Map<String, dynamic> readUnreadNotificationsCountForSelectedCompany(Map<String, dynamic> responseMap) {
    var sift = Sift();

    try {
      var selectedCompanyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
      var companiesCountMap = sift.readMapFromMap(responseMap, 'companies_count');
      var selectedCompanyCountMap = sift.readMapFromMap(companiesCountMap, selectedCompanyId);
      return selectedCompanyCountMap;
    } on SiftException catch (_) {
      throw InvalidResponseException();
    }
  }
}
