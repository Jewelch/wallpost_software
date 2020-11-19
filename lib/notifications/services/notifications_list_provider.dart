import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';
import 'package:wallpost/notifications/entities/notification.dart';
import 'package:wallpost/notifications/services/notification_factory.dart';

class NotificationsListProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  NotificationsListProvider.initWith(
      this._selectedCompanyProvider, this._networkAdapter);

  NotificationsListProvider()
      : this._selectedCompanyProvider = SelectedCompanyProvider(),
        this._networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<Notification>> getNext() async {
    var selectedCompany =
        _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    var url = NotificationUrls.notificationsListUrl(
        selectedCompany.id, _pageNumber, _perPage);
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

  Future<List<Notification>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<List<Notification>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>)
      throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<Notification> _readItemsFromResponse(
      List<Map<String, dynamic>> responseMapList) {
    try {
      var notificationList = <Notification>[];
      for (var responseMap in responseMapList) {
        var notification = NotificationFactory.createNotification(responseMap);
        notificationList.add(notification);
      }
      _updatePaginationRelatedData(notificationList.length);
      return notificationList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }

  bool get didReachListEnd => _didReachListEnd;
}
