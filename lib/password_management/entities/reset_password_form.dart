// @dart=2.9

import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ResetPasswordForm implements JSONConvertible {
  final String accountno;
  final String email;

  ResetPasswordForm(
    this.accountno,
    this.email,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'accountno': accountno,
      'email': email,
    };
  }
}
