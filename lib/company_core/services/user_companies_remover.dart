import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

class UserCompaniesRemover {
  late CompanyRepository _companyRepository;

  UserCompaniesRemover() {
    _companyRepository = CompanyRepository.getInstance();
  }

  UserCompaniesRemover.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void removeCompaniesForUser(User user) {
    _companyRepository.removeCompaniesForUser(user);
  }
}
