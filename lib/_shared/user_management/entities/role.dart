import 'package:wallpost/_shared/user_management/entities/role_type.dart';

class Role {
  final RoleType roleType;
  final String associatedUserId;
  bool _isActive;

  Role(this.roleType, this.associatedUserId, {bool isActive = true}) {
    this._isActive = isActive;
  }

  bool get isActive => _isActive;
}
