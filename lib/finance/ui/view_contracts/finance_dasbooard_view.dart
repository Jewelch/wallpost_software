import 'package:wallpost/finance/entities/finance_invoice_details.dart';

abstract class FinanceDasBoardView{
  void showLoader();

  void showErrorAndRetryView(String message);

  void onDidLoadFinanceDashBoardData();

  void showFinanceDashboardFilter();


}