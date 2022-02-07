import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/dashboard_management/entities/Dashboard.dart';

abstract class CompaniesListView {
  void showLoader();

  void hideLoader();

  void showSearchBar();

  void hideSearchBar();

  void showCompanyList(List<Company>? companies);

  void showNoCompaniesMessage(String message);

  void showNoSearchResultsMessage(String message);

  void showErrorMessage(String message);

  void onCompanyDetailsLoadedSuccessfully();

  void onCompanyDetailsLoadingFailed(String title, String message);

  void showSelectedCompany(Company? company);

  void showLogoutAlert(String title, String message);

  void showProfileImage(String url);

  void showSummary(GroupSummary groupSummary);

  void showCompanyGroups(List<CompaniesGroup> companyGroups);
}
