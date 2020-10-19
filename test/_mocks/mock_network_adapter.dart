import 'package:wallpost/_shared/network_adapter/network_adapter.dart';

export 'package:wallpost/_shared/network_adapter/network_adapter.dart';

class MockNetworkAdapter implements NetworkAdapter {
  bool _shouldSucceed;
  dynamic _data;
  int _delay = 0;
  Map<String, Object> _metadata = {};
  APIException _apiException;
  APIRequest _apiRequest;
  var didCallGet = false;
  var didCallPut = false;
  var didCallPost = false;
  int noOfTimesGetIsCalled = 0;
  int noOfTimesPostIsCalled = 0;
  int noOfTimesPutIsCalled = 0;

  APIRequest get apiRequest => _apiRequest;

  void reset() {
    didCallGet = false;
    didCallPut = false;
    didCallPost = false;
    noOfTimesGetIsCalled = 0;
    noOfTimesPostIsCalled = 0;
    noOfTimesPutIsCalled = 0;
  }

  void succeed(dynamic data, {int afterDelayInMilliSeconds = 0}) {
    _shouldSucceed = true;
    _data = data;
    _delay = afterDelayInMilliSeconds;
  }

  void fail(APIException apiException) {
    _shouldSucceed = false;
    _apiException = apiException;
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest) {
    didCallGet = true;
    noOfTimesGetIsCalled++;
    return _processRequest(apiRequest);
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) {
    didCallPost = true;
    noOfTimesPostIsCalled++;
    return _processRequest(apiRequest);
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) {
    didCallPut = true;
    noOfTimesPutIsCalled++;
    return _processRequest(apiRequest);
  }

  Future<APIResponse> _processRequest(APIRequest apiRequest) async {
    _apiRequest = apiRequest;
    if (_shouldSucceed) {
      if (_delay > 0) await Future.delayed(Duration(milliseconds: _delay));
      int statusCode = 200;
      return Future.value(APIResponse(apiRequest, statusCode, _data, _metadata));
    } else {
      throw _apiException;
    }
  }
}
