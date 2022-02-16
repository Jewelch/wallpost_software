import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

class RepositoryInitializer {
  //TODO: Obaid write tests with Aymen
  Future<void> initializeRepos() async {
    await UserRepository.initRepo();
    await CompanyRepository.initRepo();
    await AllowedActionsRepository.initRepo();
  }
}
