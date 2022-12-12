
import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import 'finance_bill_report.dart';
import 'finance_cash_report.dart';
import 'finance_invoice_report.dart';

class FinanceDashBoardData extends JSONInitializable{

  late String _profitAndLoss;
  late String _income;
  late String _expenses;
  late String _bankAndCash;
  late String _cashIn;
  late String _cashOut;
  FinanceCashReport? _financeCashReport;
  FinanceInvoiceReport? _financeInvoiceReport;
  FinanceBillReport? _financeBillReport;

  FinanceDashBoardData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {

      _profitAndLoss = '${sift.readStringFromMap(jsonMap, 'profit_and_loss')}';
      _income = '${sift.readStringFromMap(jsonMap, 'income')}';
      _expenses = '${sift.readStringFromMap(jsonMap, 'expenses')}';
      _bankAndCash = '${sift.readStringFromMap(jsonMap, 'bank_and_cashe')}';
      _cashIn = '${sift.readStringFromMap(jsonMap, 'cashe_in')}';
      _cashOut = '${sift.readStringFromMap(jsonMap, 'cashe_out')}';

      var financialCashReportMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'chart_data', null);
      var financialInvoiceReportMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'invoice_report', null);
      var financialBillReportMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'bill_report', null);


      if (financialCashReportMap != null) _financeCashReport = FinanceCashReport.fromJson(financialCashReportMap);
      if (financialInvoiceReportMap != null) _financeInvoiceReport = FinanceInvoiceReport.fromJson(financialInvoiceReportMap);
      if (financialBillReportMap != null) _financeBillReport = FinanceBillReport.fromJson(financialBillReportMap);

    } on SiftException catch (e) {
      throw MappingException('Failed to cast Finance dashboard response. Error message - ${e.errorMessage}');
    }
  }

  FinanceBillReport? get financeBillReport => _financeBillReport;

  FinanceInvoiceReport? get financeInvoiceReport => _financeInvoiceReport;

  FinanceCashReport? get financeCashReport => _financeCashReport;

  String get cashOut => _cashOut;

  String get cashIn => _cashIn;

  String get bankAndCash => _bankAndCash;

  String get expenses => _expenses;

  String get income => _income;

  String get profitAndLoss => _profitAndLoss;
}