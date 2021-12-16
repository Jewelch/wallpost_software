// @dart=2.9

import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class Credentials implements JSONConvertible {
  final String accountNumber;
  final String username;
  final String password;

  Credentials(this.accountNumber, this.username, this.password);

  @override
  Map<String, dynamic> toJson() {
    return {
      'accountno': accountNumber,
      'password': password,
      'username': username,
    };
  }
}
