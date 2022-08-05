import 'package:flutter/foundation.dart';
import 'package:wallpost/_shared/device/device_info.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/user_management/constants/login_urls.dart';
import 'package:wallpost/_wp_core/user_management/entities/credentials.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/services/new_user_adder.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

class Authenticator {
  final DeviceInfoProvider _deviceInfo;
  final NewUserAdder _newUserAdder;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  Authenticator.initWith(
    this._deviceInfo,
    this._newUserAdder,
    this._networkAdapter,
  );

  Authenticator()
      : _deviceInfo = DeviceInfoProvider(),
        _newUserAdder = NewUserAdder(),
        _networkAdapter = WPAPI();

  Future<User> login(Credentials credentials) async {
    var url = LoginUrls.authUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(credentials.toJson());
    apiRequest.addParameters({
      'apptype': 'MOBILE',
      'deviceuid': await _deviceInfo.getDeviceId(),
      'environment': kReleaseMode ? 'Production' : 'Development',
      'deviceos': await _deviceInfo.getDeviceOS(),
      'devicemodel': await _deviceInfo.getDeviceModel(),
      'appversion': await _deviceInfo.getAppVersion(),
    });
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      if (exception is HTTPException && exception.httpCode == 401) {
        throw ServerSentException('Invalid username or password', 401);
      } else {
        throw exception;
      }
    }
  }

  Future<User> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var user = User.fromJson(responseMap);
      await _newUserAdder.addUser(user);
      return user;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
