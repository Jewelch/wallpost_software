import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/user_management/entities/session.dart';
import 'package:wallpost/_shared/user_management/entities/user_roles.dart';
import 'package:sift/Sift.dart';

class User extends JSONInitializable implements JSONConvertible {
  String _userId;
  String _username;
  String _companyId;
  bool _isFirstLogin;
  UserRoles _roles;
  Session _session;

  User.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _userId = sift.readStringFromMap(jsonMap, 'user_id');
      _username = sift.readStringFromMap(jsonMap, 'username');
      _companyId = sift.readNumberFromMap(jsonMap, 'company_id').toString();
      _isFirstLogin = sift.readBooleanFromMap(jsonMap, 'firstLogin');
      _roles = UserRoles.fromJson(jsonMap);
      _session = Session.fromJson(jsonMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast User response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'user_id': _userId,
      'username': _username,
      'company_id': int.parse(_companyId),
      'firstLogin': _isFirstLogin,
      'user_master_ids': _roles.toJson(),
    };
    jsonMap.addAll(_session.toJson());
    return jsonMap;
  }

  String get userId => _userId;

  String get username => _username;

  String get companyId => _companyId;

  Session get session => _session;

  bool isATraveller() {
    return _roles.isATraveller();
  }

  bool isARetailer() {
    return _roles.isARetailer();
  }

  bool isAnOwner() {
    return _roles.isAnOwner();
  }

  bool hasMultipleRoles() {
    return (isATraveller() && isARetailer()) ||
        (isATraveller() && isAnOwner()) ||
        (isARetailer() && isAnOwner()) ||
        (isATraveller() && isARetailer() && isAnOwner());
  }

  bool isTravellerAccountActive() {
    return _roles.isTravellerAccountActive();
  }

  bool isRetailerAccountActive() {
    return _roles.isRetailerAccountActive();
  }

  bool isOwnerAccountActive() {
    return _roles.isOwnerAccountActive();
  }

  String getTravellerId() {
    return _roles.getTravellerId();
  }

  String getRetailerId() {
    return _roles.getRetailerId();
  }

  String getOwnerId() {
    return _roles.getOwnerId();
  }

  void updateRoles(UserRoles roles) {
    _roles = roles;
  }

  bool isLoggingInForTheFirstTime() {
    return true;
    return _isFirstLogin;
  }

  void updateAccessToken(String accessToken, num expirationTimeStamp) {
    _session.updateAccessToken(accessToken, expirationTimeStamp);
  }
}
