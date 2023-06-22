import '../../../../_shared/date_range_selector/entities/date_range.dart';

class ProfitsLossesReportFilters {
  DateRange dateFilters = DateRange()..applyThisYear();

  ProfitsLossesReportFilters copy() {
    var profitLossFilters = ProfitsLossesReportFilters();
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
