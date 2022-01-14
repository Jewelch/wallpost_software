import 'package:wallpost/_wp_core/company_management/entities/company.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';

abstract class CompaniesListView {
  
  void showLoader();

  void hideLoader();

  void showSearchBar();

  void hideSearchBar();

  void showCompanyList(List<CompanyListItem> companies);

  void showNoCompaniesMessage(String message);

  void showNoSearchResultsMessage(String message);

  void showErrorMessage(String message);

  void onCompanyDetailsLoadedSuccessfully();

  void onCompanyDetailsLoadingFailed(String title, String message);

  void showSelectedCompany(CompanyListItem? company);

}
