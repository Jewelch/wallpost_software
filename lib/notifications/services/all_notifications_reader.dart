import 'dart:async';

import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/_wp_core/wpapi/wp_api.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';

class AllNotificationsReader {
  final CurrentUserProvider _currentUserProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  AllNotificationsReader()
      : _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  AllNotificationsReader.initWith(
    this._currentUserProvider,
    this._selectedCompanyProvider,
    this._networkAdapter,
  );

  Future<void> markAllAsRead() async {
    var userId = _currentUserProvider.getCurrentUser().id;
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = NotificationUrls.markAllNotificationsAsReadUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameter('user_id', userId);
    isLoading = true;

    try {
      await _networkAdapter.postWithNonce(apiRequest);
      isLoading = false;
      return null;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}
