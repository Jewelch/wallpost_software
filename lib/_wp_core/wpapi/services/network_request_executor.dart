import 'dart:convert';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';

import '../../../_shared/helpers/pretty_dio_logger.dart';
import 'network_adapter.dart';

class NetworkRequestExecutor implements NetworkAdapter {
  Dio dio = new Dio();

  NetworkRequestExecutor() {
    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false,
      maxWidth: 90,
    ));
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
  Future<APIResponse> postWithNonce(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'POST');
  }

  @override
  Future<APIResponse> postWithFormData(APIRequest apiRequest) async {
    return executeRequestWithFormData(apiRequest);
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'PUT');
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'DELETE');
  }

  Future<APIResponse> executeRequest(APIRequest apiRequest, String method) async {
    if (await _isConnected() == false) throw NetworkFailureException();

    try {
      print(apiRequest.url);
      Response<String> response = await dio.request(
        apiRequest.url,
        data: jsonEncode(apiRequest.parameters),
        options: Options(
          method: method,
          headers: apiRequest.headers,
          validateStatus: (status) => status == 200,
        ),
      );
      print(1);
      print(response);
      print(2);
      print(response.data);
      print(3);
      print(response.extra);
      print(4);
      print(response.statusCode);
      return _processResponse(response, apiRequest);
    } on DioException catch (error) {
      throw _processError(error);
    }
  }

  Future<APIResponse> executeRequestWithFormData(APIRequest apiRequest) async {
    if (await _isConnected() == false) throw NetworkFailureException();

    try {
      var formData = FormData.fromMap(apiRequest.parameters);
      Response<String> response = await dio.post(
        apiRequest.url,
        data: formData,
        options: Options(
          headers: apiRequest.headers,
          validateStatus: (status) => status == 200,
        ),
      );
      return _processResponse(response, apiRequest);
    } on DioException catch (error) {
      throw _processError(error);
    }
  }

  Future<bool> _isConnected() {
    return DataConnectionChecker().hasConnection;
  }

  APIResponse _processResponse(Response response, APIRequest apiRequest) {
    try {
      var responseData = json.decode(response.data);
      return APIResponse(apiRequest, response.statusCode!, responseData, {});
    } catch (e) {
      throw UnexpectedResponseFormatException();
    }
  }

  APIException _processError(DioException error) {
    if (error.response == null || error.response!.statusCode == null) {
      //Something happened in setting up or sending the request that triggered an Error
      return RequestException(error.message ?? "");
    } else {
      // The request was made and the server responded with a statusCode != 200
      return HTTPException(error.response!.statusCode!, error.response!.data);
    }
  }
}
