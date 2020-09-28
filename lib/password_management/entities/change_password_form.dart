import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ChangePasswordForm implements JSONConvertible {
  final String newPassword;
  final String oldPassword;

  ChangePasswordForm(
    this.newPassword,
    this.oldPassword,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'newpassword': newPassword,
      'oldpassword': oldPassword,
    };
  }
}
