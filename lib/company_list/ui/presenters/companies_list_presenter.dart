import 'dart:developer';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_list/entities/company_group.dart';
import 'package:wallpost/company_list/entities/company_list.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';
import 'package:wallpost/company_list/services/company_list_provider.dart';
import 'package:wallpost/company_list/services/company_details_provider.dart';
import 'package:wallpost/company_list/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_list/ui/view_contracts/company_list_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CompanyListProvider _companyListProvider;
  final CompanyDetailsProvider _companyDetailsProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final CurrentUserProvider _currentUserProvider;
  late CompanyList _companyList;
  List<CompanyListItem> _companies = [];
  List<CompanyListItem> _filterList = [];

  //List<CompanyGroup> _groups = [];
  var _searchText = "";

  CompaniesListPresenter(this._view)
      : _companyListProvider = CompanyListProvider(),
        _companyDetailsProvider = CompanyDetailsProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        _currentUserProvider = CurrentUserProvider();

  CompaniesListPresenter.initWith(
      this._view,
      this._companyListProvider,
      this._companyDetailsProvider,
      this._selectedCompanyProvider,
      this._currentUserProvider);

  Future<void> getProfileImageUrl() async {
    try {
      var profileImageUrl =
          _currentUserProvider.getCurrentUser().profileImageUrl;
      _view.showProfileImage(profileImageUrl);
    } on WPException catch (e) {
      // load currentUser image url error
      log(e.toString());
    }
  }

  Future<void> loadCompanies() async {
    if (_companyListProvider.isLoading) return;
    _companies.clear();
    _view.showLoader();

    try {
      var companyList = await _companyListProvider.get();
      _handleResponse(companyList);
      _companyList = companyList;
      _view.hideLoader();
    } on WPException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  // CurrentUserProvider().getCurrentUser().profileImageUrl

  Future<void> refreshCompanies() async {
    if (_companyListProvider.isLoading) return;
    try {
      var companies = await _companyListProvider.get();
      _handleResponse(companies);
    } on WPException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  void loadSelectedCompany() {
    //no need to do this
    // var _selectedCompany =
    //     _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    //
    // if (_selectedCompany != null) {
    //   // var _selectedCompanyListItem =
    //   //     _companies.firstWhere((selectedCompanyListItem) => selectedCompanyListItem.id == _selectedCompany.id);
    //   //
    //   // _selectedCompanyItem = _selectedCompanyListItem;
    //   //
    //   // _view.showSelectedCompany(_selectedCompanyListItem);
    // } else {
    //   // _selectedCompanyItem = null;
    // }
  }

  selectCompanyAtIndex(int index) async {
    var _selectedCompany = _filterList[index];
    selectCompany(_selectedCompany);
  }

  selectCompany(CompanyListItem companyListItem) async {
    _view.showLoader();
    try {
      var _ = await _companyDetailsProvider
          .getCompanyDetails(companyListItem.id.toString());
      _view.hideLoader();
      _view.onCompanyDetailsLoadedSuccessfully();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onCompanyDetailsLoadingFailed(
          'Failed To load company details', e.userReadableMessage);
    }
  }

  void _handleResponse(CompanyList companyList) {
    _companies = companyList.companies;

    if (companyList.groups.isNotEmpty)
      _view.showCompanyGroups(companyList.groups);

    if (companyList.financialSummary != null) {
      _view.showSummary(companyList.financialSummary!);
    }

    if (_companies.isNotEmpty) {
      _view.showSearchBar();
      loadSelectedCompany();
      _showFilteredCompanies();
    } else {
      _clearSearchTextAndHideSearchBar();
      _view.showNoCompaniesMessage(
          "There are no companies.\n\nTap here to reload");
    }
  }

  void _showFilteredCompanies() {
    _filterList.clear();
    for (int i = 0; i < _companies.length; i++) {
      var item = _companies[i];
      if (item.name.toLowerCase().contains(_searchText.toLowerCase())) {
        _filterList.add(item);
      }
    }

    if (_filterList.isEmpty) {
      _view.showNoSearchResultsMessage(
          "There are no companies for the  given search criteria.");
    } else {
      _view.showCompanyList(_filterList);
    }
  }

  void _clearSearchTextAndHideSearchBar() {
    _searchText = "";
    _view.hideSearchBar();
  }

  //MARK: Function to perform search

  void performSearch(String searchText) {
    _searchText = searchText;
    _showFilteredCompanies();
  }

  //MARK: Function to refresh the company list

  refresh() {
    _companyListProvider.reset();
    loadCompanies();
  }

  //MARK: Getters

  String getSearchText() {
    return _searchText;
  }

  List<CompanyListItem> getCompanies() {
    return _companies;
  }

  logout() {
    _view.showLogoutAlert("Logout", "Are you sure you want to log out?");
  }

  void showGroup(int index) {
    List<CompanyListItem> _groupCompanies = [];

    if (_companyList.groups[index].financialSummary != null) {
      _view.showSummary(_companyList.groups[index].financialSummary!);
    }

    var companyIds = _companyList.groups[index].companyIds;
    _companies.forEach((element) {
      companyIds.forEach((value) {
        if (value == element.id) _groupCompanies.add(element);
      });
    });

    if (_groupCompanies.isNotEmpty) {
      _view.showCompanyList(_groupCompanies);
    }
  }

  resetSearch() {
    performSearch("");
    _handleResponse(_companyList);
  }
}
