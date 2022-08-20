import '../../company_core/entities/company.dart';

abstract class CompaniesListView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadData();

  void updateCompanyList();

  void goToCompanyDetailScreen(Company companyListItem);

  void goToApprovalsListScreen();

  void showAttendanceWidget();
}
