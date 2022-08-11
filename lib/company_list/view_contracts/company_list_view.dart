import '../../company_core/entities/company_list_item.dart';

abstract class CompaniesListView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadData();

  void updateCompanyList();

  void goToCompanyDetailScreen(CompanyListItem companyListItem);

  void goToApprovalsListScreen();
}
