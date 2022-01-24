import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';
import 'package:wallpost/company_list/services/companies_list_provider.dart';
import 'package:wallpost/company_list/services/company_details_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CompaniesListProvider _companiesListProvider;
  final CompanyDetailsProvider _companyDetailsProvider;
  List<CompanyListItem> _companies = [];
  List<CompanyListItem> _filterList = [];
  var _searchText = "";

  CompaniesListPresenter(this._view)
      : _companiesListProvider = CompaniesListProvider(),
        _companyDetailsProvider = CompanyDetailsProvider();

  CompaniesListPresenter.initWith(
    this._view,
    this._companiesListProvider,
    this._companyDetailsProvider,
  );

  //MARK: Functions to load the list of companies

  Future<void> loadCompanies() async {
    if (_companiesListProvider.isLoading) return;
    _companies.clear();
    _view.showLoader();

    try {
      var companies = await _companiesListProvider.get();
      _handleResponse(companies);
      _view.hideLoader();
    } on WPException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  void _handleResponse(List<CompanyListItem> companies) {
    _companies.addAll(companies);
    if (_companies.isNotEmpty) {
      _view.showSearchBar();
      _showFilteredCompanies();
    } else {
      _clearSearchTextAndHideSearchBar();
      _view.showNoCompaniesMessage("There are no companies.\n\nTap here to reload");
    }
  }

  //MARK: Functions to select company at index

  selectCompanyAtIndex(int index) async {
    var _selectedCompany = _filterList[index];
    _view.showLoader();
    try {
      var _ = await _companyDetailsProvider.getCompanyDetails(_selectedCompany.id);
      _view.hideLoader();
      _view.onCompanyDetailsLoadedSuccessfully();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onCompanyDetailsLoadingFailed('Failed To load company details', e.userReadableMessage);
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
      _view.showNoSearchResultsMessage("There are no companies for the  given search criteria.");
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
    _companiesListProvider.reset();
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
}
