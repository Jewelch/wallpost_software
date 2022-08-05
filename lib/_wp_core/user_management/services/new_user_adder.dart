import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class NewUserAdder {
  late UserRepository _userRepository;

  NewUserAdder() {
    _userRepository = UserRepository.getInstance();
  }

  NewUserAdder.initWith(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  Future<void> addUser(User user) async {
    return await _userRepository.saveNewCurrentUser(user);
  }
}
