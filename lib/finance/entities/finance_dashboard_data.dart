import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import 'finance_bill_details.dart';
import 'finance_cash_monthly_detail.dart';
import 'finance_invoice_details.dart';

class FinanceDashBoardData extends JSONInitializable {
  late String _profitAndLoss;
  late String _income;
  late String _expenses;
  late String _bankAndCash;
  late String _cashIn;
  late String _cashOut;
  late FinanceCashMonthlyDetails _financeCashMonthlyDetails;
  late FinanceInvoiceDetails _financeInvoiceDetails;
  late FinanceBillDetails _financeBillDetails;

  FinanceDashBoardData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _profitAndLoss = '${sift.readStringFromMap(jsonMap, 'profit_and_loss')}';
      _income = '${sift.readStringFromMap(jsonMap, 'income')}';
      _expenses = '${sift.readStringFromMap(jsonMap, 'expenses')}';
      _bankAndCash = '${sift.readStringFromMap(jsonMap, 'bank_and_cashe')}';
      _cashIn = '${sift.readStringFromMap(jsonMap, 'cashe_in')}';
      _cashOut = '${sift.readStringFromMap(jsonMap, 'cashe_out')}';

      var financialCashMonthlyDetailsMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'chart_data', null);
      var financialInvoiceDetailsMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'invoice_report', null);
      var financialBillDetailsMap = sift.readMapFromMapWithDefaultValue(jsonMap, 'bill_report', null);

      if (financialCashMonthlyDetailsMap != null)
        _financeCashMonthlyDetails = FinanceCashMonthlyDetails.fromJson(financialCashMonthlyDetailsMap);
      if (financialInvoiceDetailsMap != null)
        _financeInvoiceDetails = FinanceInvoiceDetails.fromJson(financialInvoiceDetailsMap);
      if (financialBillDetailsMap != null) _financeBillDetails = FinanceBillDetails.fromJson(financialBillDetailsMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinanceDashBoardData response. Error message - ${e.errorMessage}');
    }
  }

  FinanceBillDetails get financeBillDetails => _financeBillDetails;

  FinanceInvoiceDetails get financeInvoiceDetails => _financeInvoiceDetails;

  FinanceCashMonthlyDetails get financeCashMonthlyDetails => _financeCashMonthlyDetails;

  String get cashOut => _cashOut;

  String get cashIn => _cashIn;

  String get bankAndCash => _bankAndCash;

  String get expenses => _expenses;

  String get income => _income;

  String get profitAndLoss => _profitAndLoss;
}
