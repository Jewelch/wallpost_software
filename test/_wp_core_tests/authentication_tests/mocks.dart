import 'package:random_string/random_string.dart';
import 'package:wallpost/_wp_core/user_management/entities/credentials.dart';

class Mocks {
  static var credentials = Credentials(
    randomString(10),
    randomString(10),
    randomString(10),
  );
  static Map<String, dynamic> loginResponse = <String, dynamic>{
    "full_name": "Obaid Mohamed",
    "profile_image":
        "https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/13\/DOC_7e25c32c-35e9-431f-b63e-3a7e7147992e.jpg",
    "refresh_token": "refToken",
    "token": "accessToken",
    "token_expiry": 1598333906,
    "user_id": "09TZ3NLA195FpWJ",
    "username": "someUserName"
  };
}
