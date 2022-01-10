
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';

class UserRepository {
  late SecureSharedPrefs _sharedPrefs;
  Map<String, User> _users = {};
  String? _currentUsername;

  static UserRepository? _singleton;

  factory UserRepository() {
    if (_singleton == null) {
      _singleton = UserRepository.initWith(SecureSharedPrefs());
    }
    return _singleton!;
  }

  UserRepository.initWith(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readUserData();
  }

  void saveNewCurrentUser(User user) async {
    _users[user.username] = user;
    _currentUsername = user.username;
    _saveUsersData();
  }

  User? getCurrentUser() {
    return _users[_currentUsername];
  }

  List<User> getAllUsers() {
    return _users.values.toList();
  }

  void updateUser(User user) async {
    _users[user.username] = user;
    _saveUsersData();
  }

  void removeUser(User user) async {
    _users.remove(user.username);
    if (_users.keys.length > 0) {
      _currentUsername = _users.keys.toList()[0];
    } else {
      _currentUsername = null;
    }

    _saveUsersData();
  }

  void _readUserData() async {
    var usersMap = await _sharedPrefs.getMap('users');
    if (usersMap != null) {
      var usersMapList = usersMap['allUsers'];
      for (Map<String, dynamic> map in usersMapList) {
        var user = User.fromJson(map);
        _users[user.username] = user;
      }
    }

    var currentUserMap = await _sharedPrefs.getMap('currentUser');
    if (currentUserMap != null) {
      _currentUsername = currentUserMap['username'];
    }
  }

  void _saveUsersData() {
    List<Map<String, dynamic>> usersDataList = [];
    for (User user in _users.values) {
      usersDataList.add(user.toJson());
    }

    _sharedPrefs.saveMap('users', {'allUsers': usersDataList});
    _sharedPrefs.saveMap('currentUser', {'username': _currentUsername});
  }
}
