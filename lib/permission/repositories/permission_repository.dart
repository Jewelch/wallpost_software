import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/permission/entities/Permission.dart';

class PermissionRepository {
  final _permissionPerfKey = "Permission";

  late SecureSharedPrefs _sharedPrefs;
  Permission? _userPermission;

  static PermissionRepository? _singleton;

  factory PermissionRepository() {
    if (_singleton == null) {
      _singleton = PermissionRepository.withSharedPrefs(SecureSharedPrefs());
    }
    return _singleton!;
  }

  PermissionRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readPermissionData();
  }

  void _readPermissionData() async {
    var permissionData = await _sharedPrefs.getMap(_permissionPerfKey);

    if (permissionData == null) return;
    var permissionJsonData = Map<String, dynamic>.from(permissionData);
    _userPermission = Permission.fromJson(permissionJsonData);
  }

  void savePermission(Permission permission) {
    _userPermission = permission;
    _sharedPrefs.saveMap(_permissionPerfKey, _userPermission!.toJson());
  }

  void removePermission() {
    _userPermission = null;
    _sharedPrefs.removeMap(_permissionPerfKey);
  }

  Permission? getPermissions() => _userPermission;
}
