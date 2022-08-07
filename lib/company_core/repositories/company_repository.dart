import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/employee.dart';

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
      'selectedEmployee':
          _shouldRetainEmployeeSelection(user, companyList.companies) ? getSelectedEmployeeForUser(user) : null,
    };
  }

  bool _shouldRetainCompanySelection(User user, List<CompanyListItem> newCompanies) {
    var selectedCompany = getSelectedCompanyForUser(user);
    if (selectedCompany == null) return false;
    return _doesListContainCompanyWithId(newCompanies, selectedCompany.id);
  }

  bool _shouldRetainEmployeeSelection(User user, List<CompanyListItem> newCompanies) {
    var selectedEmployee = getSelectedEmployeeForUser(user);
    if (selectedEmployee == null) return false;
    return _doesListContainCompanyWithId(newCompanies, selectedEmployee.companyId);
  }

  //MARK: Function to get companies list for a user

  CompanyList? getCompanyListForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]!['companyList'];
  }

  //MARK: Functions to set and get selected company and employee

  void selectCompanyAndEmployeeForUser(Company company, Employee employee, User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return;

    CompanyList companyList = _userCompanies[user.username]!['companyList'];
    if (_doesListContainCompanyWithId(companyList.companies, company.id) == false) return;
    if (_doesListContainCompanyWithId(companyList.companies, employee.companyId) == false) return;

    _userCompanies[user.username]!['selectedCompany'] = company;
    _userCompanies[user.username]!['selectedEmployee'] = employee;
  }

  Company? getSelectedCompanyForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]!['selectedCompany'];
  }

  Employee? getSelectedEmployeeForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]!['selectedEmployee'];
  }

  //MARK: Function to remove companies for user

  void removeCompaniesForUser(User user) {
    _userCompanies.remove(user.username);
  }

  //MARK: Util functions

  bool _isCompaniesDataAvailableForUser(User user) {
    return _userCompanies.containsKey(user.username);
  }

  bool _doesListContainCompanyWithId(List<CompanyListItem> companies, String companyId) {
    var filteredCompanies = companies.where((company) => company.id == companyId);
    return filteredCompanies.length > 0;
  }
}
