import 'dart:async';

import '../../../_shared/exceptions/wp_exception.dart';
import '../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/notification_urls.dart';

class NotificationTokenSynchronizer {
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool _isLoading = false;

  NotificationTokenSynchronizer() : _networkAdapter = WPAPI();

  NotificationTokenSynchronizer.initWith(this._networkAdapter);

  Future<void> syncToken(String token) async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = NotificationUrls.syncTokenUrl();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      apiRequest.addParameter('devicetoken', token);
      var apiResponse = await _networkAdapter.post(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on WPException {
      _isLoading = false;
      rethrow;
    }
  }

  void _processResponse(APIResponse apiResponse) async {
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<void>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();
    if (!(apiResponse.data as Map<String, dynamic>).containsKey("user_id")) throw InvalidResponseException();
  }

  bool get isLoading => _isLoading;
}
