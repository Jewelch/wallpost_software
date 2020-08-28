import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/network_adapter/entities/api_request.dart';
import 'package:wallpost/_shared/network_adapter/entities/api_response.dart';
import 'package:wallpost/_shared/network_adapter/network_file_uploader.dart';
import 'package:wallpost/_shared/user_management/services/access_token_provider.dart';

class WPFileUploader {
  DeviceInfoProvider _deviceInfo;
  AccessTokenProvider _accessTokenProvider;
  NetworkFileUploader _networkFileUploader;
  Dio dio = new Dio();

  WPFileUploader() {
    this._deviceInfo = DeviceInfoProvider();
    this._accessTokenProvider = AccessTokenProvider();
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

  Future<APIResponse> uploadFile(File file) async {
    if (file == null) {
      return null;
    }

    APIRequest apiRequest = APIRequest('${BaseUrls.baseUrlV2()}/fileupload/temp');
    apiRequest.addHeaders(await _buildWPHeaders());
    return _networkFileUploader.upload(file, apiRequest);
  }

  Future<Map<String, String>> _buildWPHeaders() async {
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['X-WallPost-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-WallPost-App-ID'] = AppId.appId;

    var authToken = await _accessTokenProvider.getToken();
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }
    return headers;
  }
}
