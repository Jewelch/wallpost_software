class Mocks {
  static var loginResponse = {
    "full_name": "Full User Name",
    "profile_image": "www.imageUrl.com",
    "refresh_token": "refToken",
    "token": "accessToken",
    "token_expiry": DateTime.now().millisecondsSinceEpoch + 100000,
    "user_id": "09TZ3NLA195FpWJ",
    "username": "someUserName"
  };

  static Map get userMapWithInactiveSession {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['token_expiry'] = 123;
    return map;
  }

  static final Map<String, dynamic> refreshSessionResponse = {
    'token': 'refreshedToken',
    'token_expiry': DateTime.now().millisecondsSinceEpoch + 100000,
  };
}
