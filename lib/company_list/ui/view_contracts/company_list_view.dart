import 'package:wallpost/company_list/entities/company_group.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';
import 'package:wallpost/company_list/entities/financial_summary.dart';

import '../../entities/company.dart';

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

  void showSelectedCompany(CompanyListItem company);

  void showLogoutAlert(String title, String message);

  void showProfileImage(String url);

  void showSummary(FinancialSummary groupSummary);

  void showCompanyGroups(List<CompanyGroup> companyGroups);
}
