import 'package:wallpost/_shared/network_adapter/network_adapter.dart';

export 'package:wallpost/_shared/network_adapter/network_adapter.dart';

class MockNetworkAdapter implements NetworkAdapter {
  bool _shouldSucceed;
  dynamic _data;
  Map<String, Object> _metadata = {};
  APIException _apiException;
  APIRequest _apiRequest;
  var didCallGet = false;
  var didCallPut = false;
  var didCallPost = false;

  APIRequest get apiRequest => _apiRequest;

  void succeed(dynamic data) {
    _shouldSucceed = true;
    _data = data;
  }

  void fail(APIException apiException) {
    _shouldSucceed = false;
    _apiException = apiException;
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest) {
    didCallGet = true;
    return _processRequest(apiRequest);
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) {
    didCallPut = true;
    return _processRequest(apiRequest);
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) {
    didCallPost = true;
    return _processRequest(apiRequest);
  }

  Future<APIResponse> _processRequest(APIRequest apiRequest) {
    _apiRequest = apiRequest;
    if (_shouldSucceed) {
      int statusCode = 200;
      return Future.value(APIResponse(_apiRequest, statusCode, _data, _metadata));
    } else {
      throw _apiException;
    }
  }
}
