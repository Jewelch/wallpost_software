import 'package:wallpost/company_core/entities/company_group.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

abstract class CompaniesListView {
  void showProfileImage(String url);

  void showLoader();

  void hideLoader();

  void showSearchBar();

  void hideSearchBar();

  void showCompanyGroups(List<CompanyGroup> companyGroups);

  void hideCompanyGroups();

  void showFinancialSummary(FinancialSummary groupSummary);

  void hideFinancialSummary();

  void showCompanyList(List<CompanyListItem> companies);

  void showApprovalCount(int? approvalCount);

  void hideCompanyList();

  void showErrorMessage(String message);

  void showNoSearchResultsMessage(String message);

  void goToLeftMenuScreen();

  void goToCompanyDetailScreen();

  void onCompanyDetailsLoadingFailed(String title, String message);

  void showLogoutAlert(String title, String message);

  void showAppBar(bool visibility);

  void selectGroupItem(int? index);
}
