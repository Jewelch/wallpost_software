import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/_wp_core/user_management/entities/credentials.dart';
import 'package:wallpost/_wp_core/user_management/services/authenticator.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/login/ui/contracts/login_view.dart';

class CompaniesListPresenter {
  final CompaniesListView _view;
  final CompaniesListProvider _companiesListProvider ;


  List<CompanyListItem> _companies = [];
  List<CompanyListItem> _filterList = [];

  CompaniesListPresenter(this._view) : _companiesListProvider = CompaniesListProvider();

  CompaniesListPresenter.initWith(this._view, this._companiesListProvider);

  Future<void> getCompanies() async {
    if (_companiesListProvider.isLoading) return;

    try {
      _view.showLoader();
      var companies = await _companiesListProvider.get();
      _view.hideLoader();
      _view.companiesRetrievedSuccessfully(companies);
      _companies.addAll(companies);
    } on WPException catch (e) {
      _view.hideLoader();
      _view.companiesRetrievedError("Failed To Load Companies", e.userReadableMessage);
    }
  }

  void performSearch(String searchText) {
    _filterList.clear();
    for (int i = 0; i < _companies.length; i++) {
      var item = _companies[i];
      if (item.name.toLowerCase().contains(searchText.toLowerCase())) {
        _filterList.add(item);
      }
    }
    _view.companiesRetrievedSuccessfully(_filterList);
  }

}
