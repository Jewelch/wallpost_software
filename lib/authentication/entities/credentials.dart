import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class Credentials implements JSONConvertible {
  final String username;
  final String password;

  Credentials(this.username, this.password);

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'username': username,
    };
  }
}
