import 'dart:io';

import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/device/device_info.dart';
import 'package:wallpost/_wp_core/user_management/services/access_token_provider.dart';
import 'package:wallpost/_wp_core/wpapi/entities/api_request.dart';
import 'package:wallpost/_wp_core/wpapi/entities/api_response.dart';
import 'package:wallpost/_wp_core/wpapi/entities/file_upload_response.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/api_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/missing_uploaded_file_names_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_file_uploader.dart';
import 'package:wallpost/_wp_core/wpapi/services/nonce_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wpapi_response_processor.dart';

class WPFileUploader {
  late DeviceInfoProvider _deviceInfo;
  late AccessTokenProvider _accessTokenProvider;
  late NonceProvider _nonceProvider;
  late NetworkFileUploader _networkFileUploader;

  WPFileUploader() {
    this._deviceInfo = DeviceInfoProvider();
    this._accessTokenProvider = AccessTokenProvider();
    this._nonceProvider = NonceProvider();
    this._networkFileUploader = NetworkFileUploader();
  }

  Future<FileUploadResponse> upload(List<File> files, {Function(double)? onUploadProgress}) async {
    if (files.isEmpty) throw RequestException('no files attached');

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

  FileUploadResponse _processResponse(APIResponse response, APIRequest apiRequest) {
    var processedResponse = WPAPIResponseProcessor().processResponse(response);
    var responseData = processedResponse["response"];

    List<String> uploadedFileNames = [];
    if (responseData is Map<String, dynamic>) {
      for (dynamic value in responseData.values) {
        if (value is String) uploadedFileNames.add(value);
      }
    }

    if (uploadedFileNames.isEmpty) throw MissingUploadedFileNamesException();
    return FileUploadResponse(uploadedFileNames);
  }
}
