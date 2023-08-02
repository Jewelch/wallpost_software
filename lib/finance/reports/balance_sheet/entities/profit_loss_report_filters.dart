import '../../../../_shared/date_range_selector/entities/date_range.dart';

class BalanceSheetReportFilters {
  DateRange dateFilters = DateRange()..applyThisYear();

  BalanceSheetReportFilters copy() {
    var profitLossFilters = BalanceSheetReportFilters();
    profitLossFilters.dateFilters = dateFilters.copy();
    return profitLossFilters;
  }

  List<String> toReadableListOfString() {
    return [dateFilters.toReadableString()];
  }

  void reset() {
    dateFilters = DateRange()..applyThisYear();
  }
}
