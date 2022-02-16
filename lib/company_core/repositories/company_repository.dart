import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/employee.dart';

class CompanyRepository {
  late SecureSharedPrefs _sharedPrefs;
  Map<String, Map> _userCompanies = {};

  static CompanyRepository? _singleton;

  // ignore: unused_element
  CompanyRepository._();

  static Future<void> initRepo() async {
    await getInstance()._readCompaniesData();
  }

  static CompanyRepository getInstance() {
    if (_singleton == null) {
      _singleton = CompanyRepository.withSharedPrefs(SecureSharedPrefs());
    }
    return _singleton!;
  }

  CompanyRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readCompaniesData();
  }

  //MARK: Functions to save companies for a user

  void saveCompanyListForUser(CompanyList companyList, User user) {
    _userCompanies[user.username] = {
      'companyList': companyList,
      'selectedCompany':
          _shouldRetainCompanySelection(user, companyList.companies) ? getSelectedCompanyForUser(user) : null,
      'selectedEmployee':
          _shouldRetainEmployeeSelection(user, companyList.companies) ? getSelectedEmployeeForUser(user) : null,
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
    _saveCompaniesData();
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

  //MARK: Functions to read user companies data from the storage

  Future<void> _readCompaniesData() async {
    var allUsersCompaniesMap = await _sharedPrefs.getMap('allUsersCompanies');

    if (allUsersCompaniesMap == null) return;

    for (String key in allUsersCompaniesMap.keys) {
      var username = key;
      Map companiesData = allUsersCompaniesMap[key];
      _userCompanies[username] = _readCompaniesFromMap(username, companiesData);
    }
  }

  Map _readCompaniesFromMap(String username, Map companiesData) {
    Map<String, dynamic> companyListMap = companiesData['companyList'];
    var companyList = CompanyList.fromJson(companyListMap);

    Map<String, dynamic>? selectedCompanyMap = companiesData['selectedCompany'];
    var selectedCompany = selectedCompanyMap == null ? null : Company.fromJson(selectedCompanyMap);

    Map<String, dynamic>? selectedEmployeeMap = companiesData['selectedEmployee'];
    var selectedEmployee = selectedEmployeeMap == null ? null : Employee.fromJson(selectedEmployeeMap);

    return {
      'companyList': companyList,
      'selectedCompany': selectedCompany,
      'selectedEmployee': selectedEmployee,
    };
  }

  //MARK: Functions to save user companies data to the storage

  void _saveCompaniesData() {
    Map allUsersCompaniesMap = {};

    for (String key in _userCompanies.keys) {
      var username = key;
      Map userCompanyListMap = _userCompanies[key]!;
      allUsersCompaniesMap[username] = _convertCompanyListToMap(userCompanyListMap);
    }
    _sharedPrefs.saveMap('allUsersCompanies', allUsersCompaniesMap);
  }

  Map _convertCompanyListToMap(Map userCompanyListMap) {
    CompanyList companyList = userCompanyListMap['companyList'];

    Company? selectedCompany = userCompanyListMap['selectedCompany'];
    Map? selectedCompanyMap = selectedCompany == null ? null : selectedCompany.toJson();

    Employee? selectedEmployee = userCompanyListMap['selectedEmployee'];
    Map? selectedEmployeeMap = selectedEmployee == null ? null : selectedEmployee.toJson();

    return {
      'companyList': companyList.toJson(),
      'selectedCompany': selectedCompanyMap,
      'selectedEmployee': selectedEmployeeMap,
    };
  }
}
