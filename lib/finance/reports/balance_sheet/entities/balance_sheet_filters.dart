import '../../../../_shared/date_range_selector/entities/date_range.dart';

class BalanceSheetReportFilters {
  DateRange dateFilters = DateRange()..applyThisYear();

  BalanceSheetReportFilters copy() {
    var filters = BalanceSheetReportFilters();
    filters.dateFilters = dateFilters.copy();
    return filters;
  }

  List<String> toReadableListOfString() {
    return [dateFilters.toReadableString()];
  }

  void reset() {
    dateFilters = DateRange()..applyThisYear();
  }
}
