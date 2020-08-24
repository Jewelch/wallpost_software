import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/constants/device_info.dart';
import 'package:wallpost/_shared/network_adapter/network_adapter.dart';
import 'package:wallpost/_shared/network_adapter/network_request_executor.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';

class AccessTokenProvider {
  UserRepository _userRepository;
  DeviceInfoProvider _deviceInfoProvider;
  NetworkAdapter _networkAdapter;

  AccessTokenProvider() {
    _userRepository = UserRepository();
    _deviceInfoProvider = DeviceInfoProvider();
    _networkAdapter = NetworkRequestExecutor();
  }

  AccessTokenProvider.initWith(this._userRepository, this._deviceInfoProvider, this._networkAdapter);

  Future<String> getToken() async {
    var user = _userRepository.getCurrentUser();
    if (user != null && user.session.isActive() == true) {
      return user.session.accessToken;
    } else if (user != null && user.session.isActive() == false) {
      var refreshedToken = await _refreshSessionForUser(user);
      return refreshedToken;
    } else {
      return null;
    }
  }

  Future<String> _refreshSessionForUser(User user) async {
    var apiRequest = APIRequest('${BaseUrls.baseUrlV2()}/auth/refresh');
    var inactiveSession = user.session;
    apiRequest.addHeader('Authorization', inactiveSession.accessToken);
    apiRequest.addParameters({
      'refresh_token': user.session.refreshToken,
      'username': user.username,
      'deviceuid': await _deviceInfoProvider.getDeviceId(),
    });

    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      var accessToken = _processResponse(apiResponse, user);
      return accessToken;
    } catch (e) {
      return null;
    }
  }

  String _processResponse(APIResponse apiResponse, User user) {
    if (apiResponse.data == null || apiResponse.data is! Map<String, dynamic>) {
      return null;
    }

    var responseMap = apiResponse.data as Map<String, dynamic>;
    var sift = Sift();
    try {
      var token = sift.readStringFromMap(responseMap, 'token');
      var expirationTimeStamp = sift.readNumberFromMap(responseMap, 'token_expiry');
      user.updateAccessToken(token, expirationTimeStamp);
      _userRepository.updateUser(user);
      return user.session.accessToken;
    } catch (e) {
      return null;
    }
  }
}
