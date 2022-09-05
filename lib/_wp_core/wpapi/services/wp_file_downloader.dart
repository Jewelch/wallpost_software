import 'dart:io';

import 'package:wallpost/_wp_core/wpapi/services/network_file_downloader.dart';

import '../entities/api_request.dart';
import '../exceptions/request_exception.dart';

class WPFileDownloader {
  late NetworkFileDownloader _networkFileDownloader;

  WPFileDownloader() {
    this._networkFileDownloader = NetworkFileDownloader();
  }

  Future<File> download(String url, {Function(double)? onDownloadProgress}) async {
    if (url.isEmpty) throw RequestException('file url is empty');

    APIRequest apiRequest = APIRequest(url);
    return await _networkFileDownloader.downloadFile(
      apiRequest,
      onDownloadProgress: onDownloadProgress,
    );
  }
}
