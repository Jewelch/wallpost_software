import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/services/company_details_provider.dart';
import 'package:wallpost/company_core/services/company_list_provider.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CurrentUserProvider _currentUserProvider;
  final CompanyListProvider _companyListProvider;
  final CompanyDetailsProvider _companyDetailsProvider;
  late CompanyList _companyList;
  List<CompanyListItem> _companies = [];
  List<CompanyListItem> _groupCompanies = [];
  List<CompanyListItem> _filterList = [];
  var _searchText = "";

  CompaniesListPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _companyListProvider = CompanyListProvider(),
        _companyDetailsProvider = CompanyDetailsProvider();

  CompaniesListPresenter.initWith(
    this._view,
    this._currentUserProvider,
    this._companyListProvider,
    this._companyDetailsProvider,
  );

  //MARK: Function to load user details

  Future<void> loadUserDetails() async {
    var profileImageUrl = _currentUserProvider.getCurrentUser().profileImageUrl;
    _view.showProfileImage(profileImageUrl);
  }

  //MARK: Function to load company list

  Future<void> loadCompanies() async {
    if (_companyListProvider.isLoading) return;
    _companies.clear();
    _view.showLoader();

    try {
      var companyList = await _companyListProvider.get();
      _view.hideLoader();
      _handleResponse(companyList);
      _companyList = companyList;
    } on WPException catch (e) {
      _view.hideLoader();
      _showError("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void _handleResponse(CompanyList companyList) {
    _companies = companyList.companies;


    if (_companies.isNotEmpty) {
      _setupFilterViews(companyList);
      _showFilteredCompanies();
    } else {
      _showError("There are no companies.\n\nTap here to reload.");
    }
  }

  void _setupFilterViews(CompanyList companyList) {
    _view.showSearchBar();

    if (companyList.groups.isNotEmpty)
      _view.showCompanyGroups(companyList.groups);
    else
      _view.hideCompanyGroups();

    if (companyList.financialSummary != null)
      _view.showFinancialSummary(companyList.financialSummary!);
    else
      _view.hideFinancialSummary();
  }

  void _showError(String message) {
    _searchText = "";
    _view.hideSearchBar();
    _view.hideCompanyGroups();
    _view.hideFinancialSummary();
    _view.hideCompanyList();
    _view.showErrorMessage(message);
  }

  void _showFilteredCompanies() {
    _filterList.clear();
    if(_groupCompanies.isNotEmpty){
      for (int i = 0; i < _groupCompanies.length; i++) {
        var item = _groupCompanies[i];
        if (item.name.toLowerCase().contains(_searchText.toLowerCase())) {
          _filterList.add(item);
        }
      }
    } else {
      for (int i = 0; i < _companies.length; i++) {
        var item = _companies[i];
        if (item.name.toLowerCase().contains(_searchText.toLowerCase())) {
          _filterList.add(item);
        }
      }
    }


    if (_filterList.isEmpty) {
      _view.showNoSearchResultsMessage("There are no companies for the  given search criteria.");
    } else {
      _view.showCompanyList(_filterList);
    }
  }

  //MARK: Function to refresh the company list

  refresh() {
    _view.hideFinancialSummary();
    _view.showAppBar(false);
    _view.selectGroupItem(null);
    _companyListProvider.reset();
    _searchText = "";
    _groupCompanies.clear();
    loadCompanies();
  }

  //MARK: Functions to perform search

  void performSearch(String searchText) {
    _searchText = searchText;
    _showFilteredCompanies();
  }

  resetSearch() {
    performSearch("");
    _groupCompanies.clear();
    _handleResponse(_companyList);
  }

  //MARK: Function to select group filter

  void showGroup(int index) {

    _groupCompanies.clear();

    if (_companyList.groups[index].financialSummary != null) {
      _view.showFinancialSummary(_companyList.groups[index].financialSummary!);
    }

    var companyIds = _companyList.groups[index].companyIds;
    _companies.forEach((element) {
      companyIds.forEach((value) {
        if (value == element.id) _groupCompanies.add(element);
      });
    });

    if (_groupCompanies.isNotEmpty) {
      _showFilteredCompanies();
    }
  }

  //MARK: Functions to select a company

  selectCompanyAtIndex(int index) async {
    var _selectedCompany = _filterList[index];
    _selectCompany(_selectedCompany);
  }

  _selectCompany(CompanyListItem companyListItem) async {
    _view.showLoader();
    try {
      var _ = await _companyDetailsProvider.getCompanyDetails(companyListItem.id.toString());
      _view.hideLoader();
      _view.goToCompanyDetailScreen();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onCompanyDetailsLoadingFailed('Failed To load company details', e.userReadableMessage);
    }
  }

  //MARK: Function to perform logout

  logout() {
    _view.showLogoutAlert("Logout", "Are you sure you want to log out?");
  }

  //MARK: Getters

  String getSearchText() {
    return _searchText;
  }

  List<CompanyListItem> getCompanies() {
    return _companies;
  }

  List<String> getYears() {
    return _years;
  }
  final List<String> _years = <String>[
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022'
  ];

}
