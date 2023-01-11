import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../_shared/helpers/pretty_dio_logger.dart';
import '../entities/api_request.dart';
import '../exceptions/file_download_exception.dart';

class NetworkFileDownloader {
  Dio dio = new Dio();

  NetworkFileDownloader() {
    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false,
      maxWidth: 90,
    ));
  }

  Future<File> downloadFile(APIRequest apiRequest, {Function(double)? onDownloadProgress}) async {
    try {
      var filename = basename(apiRequest.url);
      var dir = await getTemporaryDirectory();

      await dio.download(
        apiRequest.url,
        '${dir.path}/$filename',
        onReceiveProgress: (rec, total) {
          var progress = (rec / total) * 100;
          print("--------------------------------------------------------------------");
          print("File download progress - $progress");
          print("--------------------------------------------------------------------");
          if (onDownloadProgress != null) onDownloadProgress(progress);
        },
      );

      print("--------------------------------------------------------------------");
      print("File download complete");
      print("File path - ${dir.path}/$filename");
      print("--------------------------------------------------------------------Z");
      return File('${dir.path}/$filename');
    } catch (error) {
      throw FileDownloadException(error.toString());
    }
  }
}
