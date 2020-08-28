import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class CompanyAdder {
  CompanyRepository _companyRepository;

  CompanyAdder() {
    _companyRepository = CompanyRepository();
  }

  CompanyAdder.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void addCompaniesForUser(List<Company> companies, User user) {
    _companyRepository.saveCompaniesForUser(companies, user);
  }
}
