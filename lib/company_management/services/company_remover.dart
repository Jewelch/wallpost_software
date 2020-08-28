import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class CompanyRemover {
  CompanyRepository _companyRepository;

  CompanyRemover() {
    _companyRepository = CompanyRepository();
  }

  CompanyRemover.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void removeCompaniesForUser(User user) {
    return _companyRepository.removeCompaniesForUser(user);
  }
}
