import '../../../../_wp_core/company_management/entities/company.dart';

abstract class GroupDashboardView {
  void showLoader();

  void showErrorMessage(String message);

  void showErrorMessageBanner(String message);

  void onDidLoadData();

  void updateCompanyList();

  void goToCompanyDashboardScreen(Company company);

  void goToApprovalsListScreen();

  void showAttendanceWidget();
}
