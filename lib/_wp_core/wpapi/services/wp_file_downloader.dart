import 'dart:io';

import 'package:wallpost/_wp_core/wpapi/services/network_file_downloader.dart';

import '../../../_shared/constants/app_id.dart';
import '../../../_shared/device/device_info.dart';
import '../../user_management/services/access_token_provider.dart';
import '../entities/api_request.dart';
import '../exceptions/request_exception.dart';
import 'nonce_provider.dart';

class WPFileDownloader {
  late DeviceInfoProvider _deviceInfo;
  late AccessTokenProvider _accessTokenProvider;

  // late NonceProvider _nonceProvider;
  late NetworkFileDownloader _networkFileDownloader;

  WPFileDownloader() {
    this._deviceInfo = DeviceInfoProvider();
    this._accessTokenProvider = AccessTokenProvider();
    // this._nonceProvider = NonceProvider();
    this._networkFileDownloader = NetworkFileDownloader();
  }

  Future<File> download(String url, {Function(double)? onDownloadProgress}) async {
    if (url.isEmpty) throw RequestException('file url is empty');

    APIRequest apiRequest = APIRequest(url);
    apiRequest.addHeaders(await _buildWPHeaders());
    return await _networkFileDownloader.downloadFile(
      apiRequest,
      onDownloadProgress: onDownloadProgress,
    );
    // return _processResponse(apiResponse, apiRequest);
  }

  Future<Map<String, String>> _buildWPHeaders() async {
    var headers = Map<String, String>();
    headers['X-WallPost-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-WallPost-App-ID'] = AppId.appId;

    var authToken = await _accessTokenProvider.getToken();
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }
    // headers['X-Wp-Nonce'] = (await _nonceProvider.getNonce(headers)).value;
    return headers;
  }

// FileUploadResponse _processResponse(APIResponse response, APIRequest apiRequest) {
//   var processedResponse = WPAPIResponseProcessor().processResponse(response);
//   var responseData = processedResponse["response"];
//
//   List<String> uploadedFileNames = [];
//   if (responseData is Map<String, dynamic>) {
//     for (dynamic value in responseData.values) {
//       if (value is String) uploadedFileNames.add(value);
//     }
//   }
//
//   if (uploadedFileNames.isEmpty) throw MissingUploadedFileNamesException();
//   return FileUploadResponse(uploadedFileNames);
// }
}
