import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/entities/company_list_item.dart';
import 'package:wallpost/company_management/entities/employee.dart';

class CompanyRepository {
  SecureSharedPrefs _sharedPrefs;
  Map<String, Map> _userCompanies = {};

  static CompanyRepository _singleton;

  factory CompanyRepository() {
    if (_singleton == null) {
      _singleton = CompanyRepository.withSharedPrefs(SecureSharedPrefs());
    }
    return _singleton;
  }

  CompanyRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readCompaniesData();
  }

  //MARK: Functions to save companies for a user

  void saveCompaniesForUser(List<CompanyListItem> companies, User user) {
    _userCompanies[user.username] = {
      'companies': companies,
      'selectedCompany': _shouldRetainCompanySelection(user, companies) ? getSelectedCompanyForUser(user) : null,
      'selectedEmployee': _shouldRetainEmployeeSelection(user, companies) ? getSelectedEmployeeForUser(user) : null,
    };

    _saveCompaniesData();
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

  List<CompanyListItem> getCompaniesForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return [];

    return _userCompanies[user.username]['companies'];
  }

  //MARK: Functions to set and get selected company and employee

  void selectCompanyAndEmployeeForUser(Company company, Employee employee, User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return;

    List<CompanyListItem> companies = _userCompanies[user.username]['companies'];
    if (_doesListContainCompanyWithId(companies, company.id) == false) return;
    if (_doesListContainCompanyWithId(companies, employee.companyId) == false) return;

    _userCompanies[user.username]['selectedCompany'] = company;
    _userCompanies[user.username]['selectedEmployee'] = employee;
    _saveCompaniesData();
  }

  Company getSelectedCompanyForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]['selectedCompany'];
  }

  Employee getSelectedEmployeeForUser(User user) {
    if (_isCompaniesDataAvailableForUser(user) == false) return null;

    return _userCompanies[user.username]['selectedEmployee'];
  }

  void removeCompaniesForUser(User user) {
    _userCompanies.remove(user.username);

    _saveCompaniesData();
  }

  //MARK: Util functions

  bool _isCompaniesDataAvailableForUser(User user) {
    return _userCompanies.containsKey(user.username);
  }

  bool _doesListContainCompanyWithId(List<CompanyListItem> companies, String companyId) {
    var filteredCompanies = companies.where((company) => company.id == companyId);
    return filteredCompanies.length > 0;
  }

  //MARK: Function to read user companies data from the storage

  void _readCompaniesData() async {
    var allUsersCompaniesMap = await _sharedPrefs.getMap('allUsersCompanies');

    if (allUsersCompaniesMap == null) return;

    for (String key in allUsersCompaniesMap.keys) {
      var username = key;
      Map companiesData = allUsersCompaniesMap[key];
      _userCompanies[username] = _readCompaniesFromMap(username, companiesData);
    }
  }

  Map _readCompaniesFromMap(String username, Map companiesData) {
    List companyListItemsMapList = companiesData['companies'];
    List<CompanyListItem> companyListItems = [];
    companyListItemsMapList.forEach((map) => companyListItems.add(CompanyListItem.fromJson(map)));

    Map selectedCompanyMap = companiesData['selectedCompany'];
    var selectedCompany = selectedCompanyMap == null ? null : Company.fromJson(selectedCompanyMap);

    Map selectedEmployeeMap = companiesData['selectedEmployee'];
    var selectedEmployee = selectedEmployeeMap == null ? null : Employee.fromJson(selectedCompanyMap);

    return {
      'companies': companyListItems,
      'selectedCompany': selectedCompany,
      'selectedEmployee': selectedEmployee,
    };
  }

  //MARK: Functions to save user companies data to the storage

  void _saveCompaniesData() {
    Map allUsersCompaniesMap = {};

    for (String key in _userCompanies.keys) {
      var username = key;
      Map userCompaniesMap = _userCompanies[key];
      allUsersCompaniesMap[username] = _convertCompaniesToMap(userCompaniesMap);
    }
    _sharedPrefs.saveMap('allUsersCompanies', allUsersCompaniesMap);
  }

  Map _convertCompaniesToMap(Map userCompaniesMap) {
    List<CompanyListItem> companyListItems = userCompaniesMap['companies'];
    List<Map> companyListItemsMapList = [];
    companyListItems.forEach((companyListItem) => companyListItemsMapList.add(companyListItem.toJson()));

    Company selectedCompany = userCompaniesMap['selectedCompany'];
    Map selectedCompanyMap = selectedCompany == null ? null : selectedCompany.toJson();

    Employee selectedEmployee = userCompaniesMap['selectedEmployee'];
    Map selectedEmployeeMap = selectedEmployee == null ? null : selectedEmployee.toJson();

    return {
      'companies': companyListItemsMapList,
      'selectedCompany': selectedCompanyMap,
      'selectedEmployee': selectedEmployeeMap,
    };
  }
}
