import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/company_details_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CompaniesListProvider _companiesListProvider;
  final CompanyDetailsProvider _companyDetailsProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  List<CompanyListItem> _companies = [];
  var _searchText = "";

  late CompanyListItem _selectedCompanyItem;

  CompaniesListPresenter(this._view)
      : _companiesListProvider = CompaniesListProvider(),
        _companyDetailsProvider = CompanyDetailsProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  CompaniesListPresenter.initWith(this._view, this._companiesListProvider,
      this._companyDetailsProvider, this._selectedCompanyProvider);

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

  void loadSelectedCompany() {
    var _selectedCompany =
        _selectedCompanyProvider.getSelectedCompanyForCurrentUser();

    var _selectedCompanyListItem = _companies.firstWhere(
        (selectedCompanyListItem) =>
            selectedCompanyListItem.id == _selectedCompany.id);

    _selectedCompanyItem = _selectedCompanyListItem;

    _view.showSelectedCompany(_selectedCompanyListItem);
  }

  void selectCompanyAtIndex(int index) async {
    var _selectedCompany = _companies[index];
    selectCompany(_selectedCompany);
  }

  void selectCompany(CompanyListItem companyListItem) async {
    _view.showLoader();
    try {
      var _ =
          await _companyDetailsProvider.getCompanyDetails(companyListItem.id);
      _view.hideLoader();
      _view.onCompanyDetailsLoadedSuccessfully();
    } on WPException catch (e) {
      _view.hideLoader();
      loadCompanies();
      _view.onCompanyDetailsLoadingFailed(
          'Failed To Load Company Details', e.userReadableMessage);
    }
  }

  void _handleResponse(List<CompanyListItem> companies) {
    _companies.addAll(companies);
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
    List<CompanyListItem> _filterList = [];
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
      _filterList.remove(_selectedCompanyItem);
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
