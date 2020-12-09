import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class CurrentUserProvider {
  UserRepository _userRepository;

  CurrentUserProvider() {
    _userRepository = UserRepository();
  }

  CurrentUserProvider.initWith(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  User getCurrentUser() {
    return _userRepository.getCurrentUser();
  }
}
