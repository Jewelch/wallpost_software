import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

abstract class CompaniesListView {

  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadData();

  void updateFinancialSummary(FinancialSummary? groupSummary);

  void updateCompanyList(List<CompanyListItem> companies);

  void goToCompanyDetailScreen(String companyId);

  void goToApprovalsListScreen();
}
