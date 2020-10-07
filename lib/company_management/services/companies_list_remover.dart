import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class CompaniesListRemover {
  CompanyRepository _companyRepository;

  CompaniesListRemover() {
    _companyRepository = CompanyRepository();
  }

  CompaniesListRemover.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void removeCompaniesForUser(User user) {
    _companyRepository.removeCompaniesForUser(user);
  }
}
