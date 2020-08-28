import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class RepositoryInitializer {
  static void initializeRepos() {
    UserRepository();
    CompanyRepository();
  }
}
