import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';

class UserRepository {
  SecureSharedPrefs _sharedPrefs;

  UserRepository() {
    _sharedPrefs = SecureSharedPrefs();
  }

  UserRepository.withSharePrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
  }

  void saveNewCurrentUser(User user) async {
    _sharedPrefs.saveMap('${user.username}-userInfo', user.toJson());
    _sharedPrefs.saveMap('currentUser', {'username': user.username});
  }

  Future<User> getCurrentUser() async {
    var currentUserMap = await _sharedPrefs.getMap('currentUser');
    if (currentUserMap != null) {
      var currentUsername = currentUserMap['username'];
      var userMap = await _sharedPrefs.getMap('$currentUsername-userInfo');
      return User.fromJson(userMap);
    }
    return null;
  }

  void updateUser(User user) async {
    _sharedPrefs.saveMap('${user.username}-userInfo', user.toJson());
  }

  void removeUser(User user) async {
    _sharedPrefs.removeMap('${user.username}-userInfo');
    _sharedPrefs.removeMap('currentUser');
  }
}
