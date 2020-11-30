import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/user_management/entities/session.dart';

class User extends JSONInitializable implements JSONConvertible {
  String _id;
  String _username;
  String _fullName;
  String _profileImageUrl;
  Session _session;

  User.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = sift.readStringFromMap(jsonMap, 'user_id');
      _username = sift.readStringFromMap(jsonMap, 'username');
      _fullName = sift.readStringFromMap(jsonMap, 'full_name');
      _profileImageUrl = sift.readStringFromMap(jsonMap, 'profile_image');
      _session = Session.fromJson(jsonMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast User response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'user_id': _id,
      'username': _username,
      'full_name': _fullName,
      'profile_image': _profileImageUrl,
    };
    jsonMap.addAll(_session.toJson());
    return jsonMap;
  }

  void updateAccessToken(String accessToken, num expirationTimeStamp) {
    _session.updateAccessToken(accessToken, expirationTimeStamp);
  }

  String get id => _id;

  String get username => _username;

  String get fullName => _fullName;

  String get profileImageUrl => _profileImageUrl;

  Session get session => _session;
}
