import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CompaniesListProvider _companiesListProvider;

  List<CompanyListItem> _companies = [];

  //todo
  /*
  1. CASE - WHEN THE API RETURNS AN EMPTY LIST or THROWS AN ERROR - HIDE SEARCH BAR else - show it
  2. CASE - WHEN THE SEARCH TEXT RETURNS AN EMPTY LIST - There are no companies for the  given search criteria. ->
  3. simulate empty response by commenting out _companies.addAll(companies);
     then enter search text -> then clear it off using the x button in the search text field
     there is not empty list message
  4. Add tests
   */

  var _searchText = "";

  CompaniesListPresenter(this._view) : _companiesListProvider = CompaniesListProvider();

  CompaniesListPresenter.initWith(this._view, this._companiesListProvider);

  Future<void> getCompanies() async {
    if (_companiesListProvider.isLoading) return;

    _companies.clear();
    _view.showLoader();
    try {
      var companies = await _companiesListProvider.get();
      _companies.addAll(companies);
      _companies.isNotEmpty ? _showFilteredCompanies() : _view.showNoCompaniesMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("Failed To Load Companies", e.userReadableMessage);
    }
  }

  void performSearch(String searchText) {
    _searchText = searchText;
    _showFilteredCompanies();
  }

  void _showFilteredCompanies() {
    List<CompanyListItem> _filterList = [];
    for (int i = 0; i < _companies.length; i++) {
      var item = _companies[i];
      if (item.name.toLowerCase().contains(_searchText.toLowerCase())) {
        _filterList.add(item);
      }
    }
    _view.showCompanyList(_filterList);
  }

  refresh() {
    _companiesListProvider.reset();
    getCompanies();
  }
}
