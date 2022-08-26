import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import '../entities/api_request.dart';
import '../entities/api_response.dart';
import '../exceptions/api_exception.dart';

class NetworkFileUploader {
  Future<APIResponse> upload(List<File> files, APIRequest apiRequest, {Function(double)? onUploadProgress}) async {
    if (await _isConnected() == false) throw NetworkFailureException();

    final url = apiRequest.url;
    final request = MultipartRequest(
      'POST',
      Uri.parse(url),
      onProgress: (int bytes, int total) {
        if (onUploadProgress != null) onUploadProgress((bytes / total) * 100);
      },
    );
    request.headers.addAll(apiRequest.headers);
    request.fields['file_rename'] = 'true';

    for (File file in files) {
      var filename = file.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(filename, file.path, contentType: getMimeTypeFromFileName(filename)),
      );
    }

    try {
      final response = await request.send();
      return _processResponse(response, apiRequest);
    } catch (error) {
      throw RequestException(error.toString());
    }
  }

  Future<bool> _isConnected() {
    return DataConnectionChecker().hasConnection;
  }

  MediaType getMimeTypeFromFileName(String filename) {
    String? mimeType = mime(filename);

    if (mimeType == null) return MediaType("text", "plain");

    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    return MediaType(mimee, type);
  }

  Future<APIResponse> _processResponse(http.StreamedResponse response, APIRequest apiRequest) async {
    var responseString = await response.stream.bytesToString();
    if (response.statusCode != 200) throw HTTPException(response.statusCode, responseString);

    try {
      var responseData = json.decode(responseString);
      return APIResponse(apiRequest, 200, responseData, {});
    } catch (error) {
      throw UnexpectedResponseFormatException();
    }
  }
}

class MultipartRequest extends http.MultipartRequest {
  MultipartRequest(String method, Uri url, {this.onProgress}) : super(method, url);

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        if (onProgress != null) onProgress!(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
