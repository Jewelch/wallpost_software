import 'dart:convert';

import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/device/device_info.dart';
import 'package:wallpost/_wp_core/user_management/services/access_token_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_adapter.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_request_executor.dart';
import 'package:wallpost/_wp_core/wpapi/services/nonce_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wpapi_response_processor.dart';

export 'package:wallpost/_wp_core/wpapi/services/network_adapter.dart';

class WPAPI implements NetworkAdapter {
  late DeviceInfoProvider _deviceInfo;
  late AccessTokenProvider _accessTokenProvider;
  late NonceProvider _nonceProvider;
  late NetworkAdapter _networkAdapter;

  WPAPI() {
    this._deviceInfo = DeviceInfoProvider();
    this._accessTokenProvider = AccessTokenProvider();
    this._nonceProvider = NonceProvider();
    this._networkAdapter = NetworkRequestExecutor();
  }

  WPAPI.initWith(this._deviceInfo, this._accessTokenProvider, this._nonceProvider, this._networkAdapter);

  @override
  Future<APIResponse> get(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildWPHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return get(apiRequest, forceRefresh: true);
      } else {
        throw exception;
      }
    }
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildWPHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.put(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return put(apiRequest, forceRefresh: true);
      } else {
        throw exception;
      }
    }
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildWPHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return post(apiRequest, forceRefresh: true);
      } else {
        throw exception;
      }
    }
  }

  @override
  Future<APIResponse> postWithFormData(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildWPHeaders(forceRefresh: forceRefresh, isFormData: true));
    try {
      var apiResponse = await _networkAdapter.postWithFormData(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return post(apiRequest, forceRefresh: true);
      } else {
        throw exception;
      }
    }
  }

  @override
  Future<APIResponse> postWithNonce(APIRequest apiRequest, {bool forceRefresh = true}) async {
    var wpHeaders = await _buildWPHeaders(forceRefresh: forceRefresh);
    var nonce = await _nonceProvider.getNonce(wpHeaders);
    apiRequest.addHeaders(wpHeaders);
    apiRequest.addHeader('X-Wp-Nonce', nonce.value);

    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return postWithNonce(apiRequest, forceRefresh: true);
      } else {
        throw exception;
      }
    }
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildWPHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.delete(apiRequest);
      return _processResponse(apiResponse, apiRequest);
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return delete(apiRequest, forceRefresh: true);
      } else {
        throw exception;
      }
    }
  }

  Future<Map<String, String>> _buildWPHeaders({
    bool forceRefresh = false,
    bool isFormData = false,
  }) async {
    var headers = Map<String, String>();
    headers['Content-Type'] = isFormData ? 'application/x-www-form-urlencoded;charset=utf-8' : 'application/json';
    headers['X-WallPost-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-WallPost-App-ID'] = AppId.appId;

    var authToken = await _accessTokenProvider.getToken(forceRefresh: forceRefresh);
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }
    return headers;
  }

  APIResponse _processResponse(APIResponse response, APIRequest apiRequest) {
    var processedResponse = WPAPIResponseProcessor().processResponse(response);
    var responseData = processedResponse["response"];
    var metadata = processedResponse["metadata"];
    return APIResponse(apiRequest, response.statusCode, responseData, metadata);
  }

  bool _shouldRefreshTokenOnException(APIException apiException) {
    if (apiException is HTTPException) {
      try {
        var responseData = json.decode(apiException.responseData);
        var responseMap = responseData as Map<String, dynamic>;
        var errorCode = responseMap['code'];
        if (errorCode == 1022) return true;
      } catch (e) {
        //ignore exception as the response data is optional
      }
    }
    return false;
  }
}
