import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class Session extends JSONInitializable implements JSONConvertible {
  String _accessToken;
  num _expirationTimeStamp;
  String _refreshToken;

  Session.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _accessToken = sift.readStringFromMap(jsonMap, 'token');
      _expirationTimeStamp = sift.readNumberFromMap(jsonMap, 'token_expiry');
      _refreshToken = sift.readStringFromMap(jsonMap, 'refresh_token');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Session response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'token': _accessToken,
      'token_expiry': _expirationTimeStamp,
      'refresh_token': _refreshToken,
    };
  }

  void updateAccessToken(String accessToken, num expirationTimeStamp) {
    _accessToken = accessToken;
    _expirationTimeStamp = expirationTimeStamp;
  }

  bool isActive() {
    return _expirationTimeStamp >= DateTime.now().millisecondsSinceEpoch / 1000;
  }

  String get accessToken => _accessToken;

  num get expirationTimeStamp => _expirationTimeStamp;

  String get refreshToken => _refreshToken;
}
