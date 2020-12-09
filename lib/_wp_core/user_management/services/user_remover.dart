import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class UserRemover {
  UserRepository _userRepository;

  UserRemover() {
    _userRepository = UserRepository();
  }

  UserRemover.initWith(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  void removeUser(User user) {
    return _userRepository.removeUser(user);
  }
}
