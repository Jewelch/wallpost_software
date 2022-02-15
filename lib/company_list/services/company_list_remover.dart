import 'package:wallpost/company_list/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';

class CompanyListRemover {
  late CompanyRepository _companyRepository;

  CompanyListRemover() {
    _companyRepository = CompanyRepository();
  }

  CompanyListRemover.initWith(CompanyRepository companyRepository) {
    _companyRepository = companyRepository;
  }

  void removeCompaniesForUser(User user) {
    _companyRepository.removeCompaniesForUser(user);
  }
}
