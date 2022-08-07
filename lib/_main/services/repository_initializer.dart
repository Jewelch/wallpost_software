import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class RepositoryInitializer {
  Future<void> initializeRepos() async {
    await UserRepository.initRepo();
  }
}
