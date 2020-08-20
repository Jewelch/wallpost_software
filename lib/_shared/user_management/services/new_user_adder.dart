import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';

class NewUserAdder {
  UserRepository _userRepository;

  NewUserAdder() {
    _userRepository = UserRepository();
  }

  NewUserAdder.initWith(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  void addUser(User user) {
    return _userRepository.saveNewCurrentUser(user);
  }
}
