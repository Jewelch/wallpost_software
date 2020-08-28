import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/company_management/entities/company.dart';

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

  void saveCompaniesForUser(List<Company> companies, User user) {
    _userCompanies[user.username] = {
      'companies': companies,
      'selectedCompanyId': null,
    };

    _saveCompaniesData();
  }

  List<Company> getCompaniesForUser(User user) {
    if (!_userCompanies.containsKey(user.username)) return [];

    return _userCompanies[user.username]['companies'];
  }

  void selectCompanyForUser(Company company, User user) {
    if (!_userCompanies.containsKey(user.username)) return;

    List<Company> companies = _userCompanies[user.username]['companies'];
    if (companies.where((element) => element.companyId == company.companyId).length == 0) return;

    _userCompanies[user.username]['selectedCompanyId'] = company.companyId;
    _saveCompaniesData();
  }

  Company getSelectedCompanyForUser(User user) {
    if (!_userCompanies.containsKey(user.username)) return null;

    var selectedCompanyId = _userCompanies[user.username]['selectedCompanyId'];
    if (selectedCompanyId == null) {
      return null;
    } else {
      List<Company> companies = _userCompanies[user.username]['companies'];
      return companies.firstWhere((element) => element.companyId == selectedCompanyId);
    }
  }

  void removeCompaniesForUser(User user) {
    _userCompanies.remove(user.username);

    _saveCompaniesData();
  }

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
    List<Map> companiesMapList = companiesData['companies'];
    String selectedCompanyId = companiesData['selectedCompanyId'];

    List<Company> companies = [];
    for (Map companyMap in companiesMapList) {
      var company = Company.fromJson(companyMap);
      companies.add(company);
    }

    return {'companies': companies, 'selectedCompanyId': selectedCompanyId};
  }

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
    List<Company> userCompanies = userCompaniesMap['companies'];
    String selectedCompanyId = userCompaniesMap['selectedCompanyId'];
    List<Map> companiesMap = [];
    for (Company company in userCompanies) {
      companiesMap.add(company.toJson());
    }

    return {'companies': companiesMap, 'selectedCompanyId': selectedCompanyId};
  }
}
