import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/company_management/entities/permission.dart';

class PermissionRepository {
  final _permissionPerfKey = "Permission";

  late SecureSharedPrefs _sharedPrefs;
  Permissions? _userPermission;

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
    _userPermission = Permissions.fromJson(permissionJsonData);
  }

  void savePermission(Permissions permission) {
    _userPermission = permission;
    _sharedPrefs.saveMap(_permissionPerfKey, _userPermission!.toJson());
  }

  void removePermission() {
    _userPermission = null;
    _sharedPrefs.removeMap(_permissionPerfKey);
  }

  Permissions? getPermissions() => _userPermission;
}
