import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class UserRemover {
  late UserRepository _userRepository;

  UserRemover() {
    _userRepository = UserRepository.getInstance();
  }

  UserRemover.initWith(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  Future<void> removeUser(User user) async {
    return await _userRepository.removeUser(user);
  }
}
