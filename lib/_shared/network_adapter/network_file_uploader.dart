import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'entities/api_request.dart';
import 'entities/api_response.dart';
import 'exceptions/network_failure_exception.dart';
import 'network_response_processor.dart';

class NetworkFileUploader {
  Dio dio = new Dio();

  NetworkFileUploader() {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  Future<APIResponse> upload(File file, APIRequest apiRequest) async {
    if (await _checkConnectionStatus()) {
      try {
        var filename = file.path.split('/').last;
        var formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(file.path, filename: filename),
        });
        Response<String> response = await dio.request(
          apiRequest.url,
          data: formData,
          options: Options(
            method: 'POST',
            headers: apiRequest.headers,
          ),
        );
        var apiResponse = _processResponse(response, apiRequest);
        return apiResponse;
      } on DioError catch (error) {
        var apiResponse = _processResponse(error.response, apiRequest);
        return apiResponse;
      }
    } else {
      throw NetworkFailureException();
    }
  }

  Future<bool> _checkConnectionStatus() {
    return DataConnectionChecker().hasConnection;
  }

  APIResponse _processResponse(Response response, APIRequest apiRequest) {
    var responseData = NetworkResponseProcessor().processResponse(response);
    return APIResponse(apiRequest, response.statusCode, responseData, {});
  }
}
