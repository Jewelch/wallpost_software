import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';

abstract class CompaniesListView {

  void showLoader();

  void companiesRetrievedSuccessfully(List<CompanyListItem> companies);

  void companiesRetrievedSuccessfullyWithEmptyList();

  void companiesRetrievedError(String title, String message);

}
