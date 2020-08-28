import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class CompanySelector {
  CompanyRepository _companyRepository;

  CompanySelector() {
    _companyRepository = CompanyRepository();
  }

  CompanySelector.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void selectCompanyForUser(Company company, User user) {
    _companyRepository.selectCompanyForUser(company, user);
  }
}
