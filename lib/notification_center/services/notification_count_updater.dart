import 'dart:async';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

import '../../../_common_widgets/app_badge/app_badge.dart';
import '../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/notification_urls.dart';

class NotificationCountUpdater {
  final CurrentUserProvider _currentUserProvider;
  final NetworkAdapter _networkAdapter;
  final AppBadge _appBadge;
  bool _isLoading = false;
  late String _sessionId;

  NotificationCountUpdater()
      : _currentUserProvider = CurrentUserProvider(),
        _networkAdapter = WPAPI(),
        _appBadge = AppBadge();

  NotificationCountUpdater.initWith(
    this._currentUserProvider,
    this._networkAdapter,
    this._appBadge,
  );

  Future<void> updateCount() async {
    if (!_currentUserProvider.isLoggedIn()) {
      _appBadge.updateAppBadge(0);
      return;
    }

    var url = NotificationUrls.notificationCountUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    _isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      _isLoading = false;
      return await _processResponse(apiResponse);
    } on WPException catch (_) {
      _isLoading = false;
      //do nothing
    }
  }

  Future<void> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<void>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var companyMapList = Sift().readMapListFromMap(responseMap, "companies");
      var count = _readCount(companyMapList);
      _appBadge.updateAppBadge(count);
    } catch (e) {
      //do nothing
    }
  }

  int _readCount(List<Map<String, dynamic>> companyMapList) {
    int approvalCount = 0;
    for (var map in companyMapList) {
      var companyApprovalCount = Sift().readNumberFromMap(map, 'companyApprovalCount').toInt();
      approvalCount += companyApprovalCount;
    }
    return approvalCount;
  }

  bool get isLoading => _isLoading;
}
