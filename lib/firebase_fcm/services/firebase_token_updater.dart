import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/firebase_fcm/constants/firebase_urls.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notification_listener.dart';
import 'package:wallpost/firebase_fcm/utils/firebase_device_token_provider.dart';

class FireBaseTokenUpdater {
  final NetworkAdapter _networkAdapter;
  final FireBaseDeviceTokenProvider _deviceTokenProvider;
  late String _sessionId;
  bool isExecuting = false;

  FireBaseTokenUpdater()
      : _networkAdapter = WPAPI(),
        _deviceTokenProvider = FireBaseDeviceTokenProvider();

  FireBaseTokenUpdater.initWith(this._networkAdapter, this._deviceTokenProvider);

  Future updateToken() async {
    if (isExecuting) return;
    isExecuting = true;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = FirebaseUrls.updateTokenUrl();
    var apiRequest = APIRequest.withId(url, _sessionId);
    try {
      var token = await _deviceTokenProvider.getDeviceToken();
      apiRequest.addParameter('devicetoken', token);
      var apiResponse = await _networkAdapter.post(apiRequest);
      isExecuting = false;
      return _processResponse(apiResponse);
    } on WPException {
      isExecuting = false;
      rethrow;
    }
  }

  void _processResponse(APIResponse apiResponse) async {
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<void>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();
    if (apiResponse.data['user_id'] == null) throw WrongResponseFormatException();
    FcmNotificationListener.listen();
  }
}
