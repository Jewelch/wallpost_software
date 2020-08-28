import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';

class SelectedCompanyProvider {
  CompanyRepository _companyRepository;

  SelectedCompanyProvider() {
    _companyRepository = CompanyRepository();
  }

  SelectedCompanyProvider.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  Company getSelectedCompanyForUser(User user) {
    return _companyRepository.getSelectedCompanyForUser(user);
  }
}
