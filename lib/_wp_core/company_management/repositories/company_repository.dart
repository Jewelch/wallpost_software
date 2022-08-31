import 'package:wallpost/_wp_core/user_management/entities/user.dart';

import '../entities/company.dart';

class CompanyRepository {
  Company? _selectedCompany;

  static CompanyRepository? _singleton;

  CompanyRepository._();

  static CompanyRepository getInstance() {
    if (_singleton == null) _singleton = CompanyRepository._();
    return _singleton!;
  }

  CompanyRepository.initWith();

  //MARK: Functions to set and get selected company

  void selectCompanyForUser(Company company, User user) {
    _selectedCompany = company;
  }

  Company? getSelectedCompanyForUser(User user) {
    return _selectedCompany;
  }

  //MARK: Function to remove companies for user

  void removeSelectedCompanyForUser(User user) {
    _selectedCompany = null;
  }
}
