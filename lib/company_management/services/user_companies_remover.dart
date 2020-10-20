import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class UserCompaniesRemover {
  CompanyRepository _companyRepository;

  UserCompaniesRemover() {
    _companyRepository = CompanyRepository();
  }

  UserCompaniesRemover.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void removeCompaniesForUser(User user) {
    _companyRepository.removeCompaniesForUser(user);
  }
}
