import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';

abstract class CompaniesListView {

  void showLoader();

  void hideLoader();

  void companiesRetrievedSuccessfully(List<CompanyListItem> companies);

  void companiesRetrievedError(String title, String message);

}
