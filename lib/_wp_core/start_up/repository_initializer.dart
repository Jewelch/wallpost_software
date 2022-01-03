import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

class RepositoryInitializer {
  static void initializeRepos() {
    UserRepository();
    CompanyRepository();
  }
}
