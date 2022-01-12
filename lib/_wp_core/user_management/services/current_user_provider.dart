import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class CurrentUserProvider {
  late UserRepository _userRepository;

  CurrentUserProvider() {
    _userRepository = UserRepository.getInstance();
  }

  CurrentUserProvider.initWith(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  bool isLoggedIn() {
    return _userRepository.getCurrentUser() != null;
  }

  User getCurrentUser() {
    return _userRepository.getCurrentUser()!;
  }
}
