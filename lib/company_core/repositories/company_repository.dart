import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/company_list.dart';

class CompanyRepository {
  Map<String, Map> _userCompanies = {};

  static CompanyRepository? _singleton;

  CompanyRepository._();

  static CompanyRepository getInstance() {
    if (_singleton == null) _singleton = CompanyRepository._();
    return _singleton!;
  }

  CompanyRepository.initWith();

  //MARK: Functions to save companies for a user

  void saveCompanyListForUser(CompanyList companyList, User user) {
    _userCompanies[user.username] = {
      'companyList': companyList,
      'selectedCompany':
          _shouldRetainCompanySelection(user, companyList.companies) ? getSelectedCompanyForUser(user) : null,
    };
  }

  bool _shouldRetainCompanySelection(User user, List<Company> newCompanies) {
    var selectedCompany = getSelectedCompanyForUser(user);
    if (selectedCompany == null) return false;
    return _doesListContainCompanyWithId(newCompanies, selectedCompany.id);
  }

  //MARK: Function to get companies list for a user

  CompanyList? getCompanyListForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]!['companyList'];
  }

  //MARK: Functions to set and get selected company

  void selectCompanyForUser(Company company, User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return;

    CompanyList companyList = _userCompanies[user.username]!['companyList'];
    if (_doesListContainCompanyWithId(companyList.companies, company.id) == false) return;

    _userCompanies[user.username]!['selectedCompany'] = company;
  }

  Company? getSelectedCompanyForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]!['selectedCompany'];
  }

  //MARK: Function to remove companies for user

  void removeCompaniesForUser(User user) {
    _userCompanies.remove(user.username);
  }

  //MARK: Util functions

  bool _isCompaniesDataAvailableForUser(User user) {
    return _userCompanies.containsKey(user.username);
  }

  bool _doesListContainCompanyWithId(List<Company> companies, String companyId) {
    var filteredCompanies = companies.where((company) => company.id == companyId);
    return filteredCompanies.length > 0;
  }
}
