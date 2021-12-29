import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ChangePasswordForm implements JSONConvertible {
  final String oldPassword;
  final String newPassword;

  ChangePasswordForm({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'newpassword': newPassword,
      'oldpassword': oldPassword,
    };
  }
}
