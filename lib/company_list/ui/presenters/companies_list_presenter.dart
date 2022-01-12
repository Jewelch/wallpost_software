import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CompaniesListProvider _companiesListProvider;
  List<CompanyListItem> _companies = [];
  var _searchText = "";

  CompaniesListPresenter(this._view) : _companiesListProvider = CompaniesListProvider();

  CompaniesListPresenter.initWith(this._view, this._companiesListProvider);

  Future<void> loadCompanies() async {
    if (_companiesListProvider.isLoading) return;
    _companies.clear();
    _view.showLoader();

    try {
      var companies = await _companiesListProvider.get();
      _handleResponse(companies);
    } on WPException catch (e) {
      _clearSearchTextAndHideSearchBar();
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
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

  void _showFilteredCompanies() {
    List<CompanyListItem> _filterList = [];
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
}
