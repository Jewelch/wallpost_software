import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/finance/reports/balance_sheet/date_range_selector/entities/selectable_date_range_option.dart';

class FinanceDateRange {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  FinanceSelectableDateRangeOptions selectedRangeOption = FinanceSelectableDateRangeOptions.thisMonth;

  FinanceDateRange();

  void applyThisMonth() {
    selectedRangeOption = FinanceSelectableDateRangeOptions.thisMonth;
    endDate = DateTime.now();
    startDate = DateTime(endDate.year, endDate.month, 1);
  }

  void applyThisQuarter() {
    selectedRangeOption = FinanceSelectableDateRangeOptions.thisQuarter;
    endDate = DateTime.now();

    int quarterStartMonth;
    if ([1, 2, 3].contains(endDate.month)) {
      quarterStartMonth = 1;
    } else if ([4, 5, 6].contains(endDate.month)) {
      quarterStartMonth = 4;
    } else if ([7, 8, 9].contains(endDate.month)) {
      quarterStartMonth = 7;
    } else {
      quarterStartMonth = 10;
    }

    startDate = DateTime(endDate.year, quarterStartMonth, 1);
  }

  void applyThisYear() {
    selectedRangeOption = FinanceSelectableDateRangeOptions.thisYear;
    endDate = DateTime.now();
    startDate = DateTime(endDate.year, 1, 1);
  }

  void applyLastYear() {
    selectedRangeOption = FinanceSelectableDateRangeOptions.lastYear;
    var today = DateTime.now();
    startDate = DateTime(today.year - 1, 1, 1);
    endDate = DateTime(today.year - 1, 12, 31);
  }

  void applyCustomDate(DateTime startDay, DateTime endDay) {
    selectedRangeOption = FinanceSelectableDateRangeOptions.custom;
    startDate = startDay;
    endDate = endDay;
  }

  String toReadableString() {
    switch (this.selectedRangeOption) {
      case FinanceSelectableDateRangeOptions.thisMonth:
        return "This Month";
      case FinanceSelectableDateRangeOptions.thisQuarter:
        return "This Quarter";
      case FinanceSelectableDateRangeOptions.thisYear:
        return "This Year";
      case FinanceSelectableDateRangeOptions.lastYear:
        return "Last Year";
      case FinanceSelectableDateRangeOptions.custom:
        return startDate.toReadableStringWithHyphens() + " to " + endDate.toReadableStringWithHyphens();
    }
  }

  FinanceDateRange copy() {
    var copyDateRangeFilter = FinanceDateRange();
    copyDateRangeFilter.selectedRangeOption = selectedRangeOption;
    copyDateRangeFilter.startDate = startDate;
    copyDateRangeFilter.endDate = endDate;
    return copyDateRangeFilter;
  }

  @override
  bool operator ==(Object other) {
    if (other is! FinanceDateRange) return false;
    if (other.selectedRangeOption != selectedRangeOption) return false;
    if (other.selectedRangeOption == FinanceSelectableDateRangeOptions.custom) {
      if (other.startDate.toIso8601String() != startDate.toIso8601String()) return false;
      if (other.endDate.toIso8601String() != endDate.toIso8601String()) return false;
    }
    return true;
  }

  @override
  int get hashCode => super.hashCode;
}
