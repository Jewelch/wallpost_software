import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';

abstract class CompaniesListView {
  void showLoader();

  void showSearchBar();

  void hideSearchBar();

  void showCompanyList(List<CompanyListItem> companies);

  void showNoCompaniesMessage(String message);

  void showNoSearchResultsMessage(String message);

  void showErrorMessage(String message);
}
