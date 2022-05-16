import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'network_adapter.dart';

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
  Future<APIResponse> postWithNonce(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'POST');
  }

  @override
  Future<APIResponse> postWithFormData(APIRequest apiRequest) async {
    return executeRequestWithFormData(apiRequest, 'POST');
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
      Response<String> response = await dio.request(
        apiRequest.url,
        data: jsonEncode(apiRequest.parameters),
        options: Options(
          method: method,
          headers: apiRequest.headers,
          validateStatus: (status) => status == 200,
        ),
      );
      return _processResponse(response, apiRequest);
    } on DioError catch (error) {
      throw _processError(error);
    }
  }

  Future<APIResponse> executeRequestWithFormData(APIRequest apiRequest, String method) async {
    try {
      HttpClient c = HttpClient();
      var req = await c.postUrl(Uri.parse(apiRequest.url));
      apiRequest.headers.forEach((key, value) {
        req.headers.add(key, value);
      });
      req.add(_toFormShape(apiRequest.parameters));
      var response = await req.close();
      var stringResponse = await response.transform(utf8.decoder).join();
      var res = json.decode(stringResponse);
      return APIResponse(apiRequest, response.statusCode, res, {});
    } on DioError catch (error) {
      throw _processError(error);
    }
  }

  List<int> _toFormShape(Map map) {
    var parts = [];
    map.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(json.encode(value))}');
    });
    var formData = parts.join('&');

    return utf8.encode(formData); // utf8 encode
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

  APIException _processError(DioError error) {
    if (error.response == null || error.response!.statusCode == null) {
      //Something happened in setting up or sending the request that triggered an Error
      return RequestException(error.message);
    } else {
      // The request was made and the server responded with a statusCode != 200
      return HTTPException(error.response!.statusCode!, error.response!.data);
    }
  }
}
