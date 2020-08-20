import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/user_management/entities/role.dart';
import 'package:wallpost/_shared/user_management/entities/role_type.dart';
import 'package:sift/Sift.dart';

class UserRoles extends JSONInitializable implements JSONConvertible {
  List<Role> _roles = [];

  UserRoles.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    var userMasterIdsMap = sift.readMapFromMap(jsonMap, 'user_master_ids');

    for (String userTypeKey in userMasterIdsMap.keys) {
      var role = _createRoleFrom(userTypeKey, userMasterIdsMap);
      if (role != null) {
        _roles.add(role);
      }
    }
  }

  Role _createRoleFrom(String userTypeKey, Map<String, dynamic> map) {
    var sift = Sift();
    var roleId = sift.readStringFromMap(map, userTypeKey);

    if (userTypeKey == 'TRAVELLER') {
      return Role(RoleType.Traveller, roleId);
    } else if (userTypeKey == 'RETAILER') {
      return Role(RoleType.Retailer, roleId);
    } else if (userTypeKey == 'INACTIVE_RETAILER') {
      return Role(RoleType.Retailer, roleId, isActive: false);
    } else if (userTypeKey == 'OWNER') {
      return Role(RoleType.Owner, roleId);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return Map.fromIterable(
      _roles,
      key: (item) => _convertRoleToTypeString((item as Role)),
      value: (item) => (item as Role).associatedUserId,
    );
  }

  String _convertRoleToTypeString(Role role) {
    if (role.roleType == RoleType.Traveller) {
      return 'TRAVELLER';
    } else if (role.roleType == RoleType.Retailer && role.isActive) {
      return 'RETAILER';
    } else if (role.roleType == RoleType.Retailer && !role.isActive) {
      return 'INACTIVE_RETAILER';
    } else if (role.roleType == RoleType.Owner) {
      return 'OWNER';
    }
    return null;
  }

  bool isATraveller() {
    return _roles.where((role) => role.roleType == RoleType.Traveller).length > 0;
  }

  bool isARetailer() {
    return _roles.where((role) => role.roleType == RoleType.Retailer).length > 0;
  }

  bool isAnOwner() {
    return _roles.where((role) => role.roleType == RoleType.Owner).length > 0;
  }

  bool isTravellerAccountActive() {
    if (isATraveller()) {
      return true;
    } else {
      return false;
    }
  }

  bool isRetailerAccountActive() {
    if (isARetailer()) {
      var retailerRole = _roles.where((role) => role.roleType == RoleType.Retailer).toList()[0];
      return retailerRole.isActive;
    } else {
      return false;
    }
  }

  bool isOwnerAccountActive() {
    if (isAnOwner()) {
      return true;
    } else {
      return false;
    }
  }

  String getTravellerId() {
    if (isATraveller()) {
      var travellerRole = _roles.where((role) => role.roleType == RoleType.Traveller).toList()[0];
      return travellerRole.associatedUserId;
    } else {
      return null;
    }
  }

  String getRetailerId() {
    if (isARetailer()) {
      var retailerRole = _roles.where((role) => role.roleType == RoleType.Retailer).toList()[0];
      return retailerRole.associatedUserId;
    } else {
      return null;
    }
  }

  String getOwnerId() {
    if (isAnOwner()) {
      var ownerRole = _roles.where((role) => role.roleType == RoleType.Owner).toList()[0];
      return ownerRole.associatedUserId;
    } else {
      return null;
    }
  }
}
