import 'package:wallpost/_shared/constants/app_id.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/network_adapter/network_adapter.dart';
import 'package:wallpost/_shared/network_adapter/network_request_executor.dart';
import 'package:wallpost/_shared/user_management/services/access_token_provider.dart';
import 'package:wallpost/_shared/wpapi/wpapi_response_processor.dart';

export 'package:wallpost/_shared/network_adapter/network_adapter.dart';

class WPAPI implements NetworkAdapter {
  DeviceInfoProvider _deviceInfo;
  AccessTokenProvider _accessTokenProvider;
  NetworkAdapter _networkAdapter;

  WPAPI() {
    this._deviceInfo = DeviceInfoProvider();
    this._accessTokenProvider = AccessTokenProvider();
    this._networkAdapter = NetworkRequestExecutor();
  }

  WPAPI.initWith(this._deviceInfo, this._accessTokenProvider, this._networkAdapter);

  @override
  Future<APIResponse> get(APIRequest apiRequest) async {
    apiRequest.addHeaders(await _buildWPHeaders());
    var apiResponse = await _networkAdapter.get(apiRequest);
    return _processResponse(apiResponse, apiRequest);
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    apiRequest.addHeaders(await _buildWPHeaders());
    var apiResponse = await _networkAdapter.put(apiRequest);
    return _processResponse(apiResponse, apiRequest);
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) async {
    apiRequest.addHeaders(await _buildWPHeaders());
    var apiResponse = await _networkAdapter.post(apiRequest);
    return _processResponse(apiResponse, apiRequest);
  }

  Future<Map<String, String>> _buildWPHeaders() async {
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['X-WallPost-Device-ID'] = await _deviceInfo.getDeviceId();
    headers['X-WallPost-App-ID'] = AppId.appId;

    var authToken = await _accessTokenProvider.getToken();
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }
    return headers;
  }

  APIResponse _processResponse(APIResponse response, APIRequest apiRequest) {
    var responseData = WPAPIResponseProcessor().processResponse(response);
    return APIResponse(apiRequest, response.statusCode, responseData, {});
  }
}
