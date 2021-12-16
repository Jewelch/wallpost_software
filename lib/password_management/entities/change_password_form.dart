// @dart=2.9

import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ChangePasswordForm implements JSONConvertible {
  final String oldPassword;
  final String newPassword;

  ChangePasswordForm({
    this.oldPassword,
    this.newPassword,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'newpassword': newPassword,
      'oldpassword': oldPassword,
    };
  }
}
