import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/network_adapter/entities/api_request.dart';
import 'package:wallpost/_shared/network_adapter/entities/api_response.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/_shared/network_adapter/network_file_uploader.dart';
import 'package:wallpost/_wp_core/user_management/services/access_token_provider.dart';
import 'package:wallpost/_wp_core/wpapi/nonce_provider.dart';
import 'package:wallpost/_wp_core/wpapi/wpapi_response_processor.dart';

class WPFileUploader {
  DeviceInfoProvider _deviceInfo;
  AccessTokenProvider _accessTokenProvider;
  NonceProvider _nonceProvider;
  NetworkFileUploader _networkFileUploader;
  Dio dio = new Dio();

  WPFileUploader() {
    this._deviceInfo = DeviceInfoProvider();
    this._accessTokenProvider = AccessTokenProvider();
    this._nonceProvider = NonceProvider();
    this._networkFileUploader = NetworkFileUploader();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  Future<APIResponse> upload(List<File> files, {Function(double) onUploadProgress}) async {
    if (files == null || files.isEmpty) throw RequestException('no files attached');

    APIRequest apiRequest = APIRequest('${BaseUrls.baseUrlV2()}/fileupload/temp');
    apiRequest.addHeaders(await _buildWPHeaders());
    var apiResponse = await _networkFileUploader.upload(files, apiRequest, onUploadProgress: onUploadProgress);
    return _processResponse(apiResponse, apiRequest);
  }

  Future<Map<String, String>> _buildWPHeaders() async {
    var headers = Map<String, String>();
    headers['X-WallPost-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-WallPost-App-ID'] = AppId.appId;

    var authToken = await _accessTokenProvider.getToken();
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }
    headers['X-Wp-Nonce'] = (await _nonceProvider.getNonce(headers)).value;
    return headers;
  }

  APIResponse _processResponse(APIResponse response, APIRequest apiRequest) {
    var responseData = WPAPIResponseProcessor().processResponse(response);
    return APIResponse(apiRequest, response.statusCode, responseData, {});
  }
}
