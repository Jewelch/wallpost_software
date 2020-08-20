import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ChangePasswordForm implements JSONConvertible {
  final String confirmPassword;
  final String oldPassword;
  final String password;

  ChangePasswordForm(
    this.confirmPassword,
    this.oldPassword,
    this.password,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'confirmPassword': confirmPassword,
      'oldPassword': oldPassword,
      'password': password,
    };
  }
}
