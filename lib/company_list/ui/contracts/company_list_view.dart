import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';

abstract class CompaniesListView {
  void showLoader();

  void showCompanyList(List<CompanyListItem> companies);

  void showNoCompaniesMessage();

  void showErrorMessage(String title, String message);
}
