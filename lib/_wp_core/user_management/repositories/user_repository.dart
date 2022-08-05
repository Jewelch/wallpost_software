import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';

class UserRepository {
  late SecureSharedPrefs _sharedPrefs;
  Map<String, User> _users = {};
  String? _currentUsername;

  static UserRepository? _singleton;

  UserRepository._() : this.initWith(SecureSharedPrefs());

  UserRepository.initWith(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readUserData();
  }

  static UserRepository getInstance() {
    if (_singleton == null) _singleton = UserRepository._();
    return _singleton!;
  }

  static Future<void> initRepo() async {
    await getInstance()._readUserData();
  }

  Future<void> saveNewCurrentUser(User user) async {
    _users[user.username] = user;
    _currentUsername = user.username;
    await _saveUsersData();
  }

  User? getCurrentUser() {
    return _users[_currentUsername];
  }

  List<User> getAllUsers() {
    return _users.values.toList();
  }

  Future<void> updateUser(User user) async {
    _users[user.username] = user;
    await _saveUsersData();
  }

  Future<void> removeUser(User user) async {
    _users.remove(user.username);
    if (_users.keys.length > 0) {
      _currentUsername = _users.keys.toList()[0];
    } else {
      _currentUsername = null;
    }

    await _saveUsersData();
  }

  Future<void> _readUserData() async {
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

  Future<void> _saveUsersData() async {
    List<Map<String, dynamic>> usersDataList = [];
    for (User user in _users.values) {
      usersDataList.add(user.toJson());
    }

    await _sharedPrefs.saveMap('users', {'allUsers': usersDataList});
    await _sharedPrefs.saveMap('currentUser', {'username': _currentUsername});
  }
}
