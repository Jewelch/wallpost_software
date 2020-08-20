import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'network_adapter.dart';
import 'network_response_processor.dart';

class NetworkRequestExecutor implements NetworkAdapter {
  Dio dio = new Dio();

  NetworkRequestExecutor() {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'GET');
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'POST');
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'PUT');
  }

  Future<APIResponse> executeRequest(APIRequest apiRequest, String method) async {
    if (await _checkConnectionStatus()) {
      try {
        Response<String> response = await dio.request(
          apiRequest.url,
          options: Options(
            method: method,
            headers: apiRequest.headers,
          ),
          data: jsonEncode(apiRequest.parameters),
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
