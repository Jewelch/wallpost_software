import '../../entities/date_range.dart';
import '../../entities/selectable_date_range_option.dart';

class FinanceDateRangePresenter {
  FinanceDateRange dateRange = FinanceDateRange();

  void onSelectDateRangeOption(FinanceSelectableDateRangeOptions selectableDateRangeOptions,
      {DateTime? customStartDate, DateTime? customEndDate}) {
    switch (selectableDateRangeOptions) {
      case FinanceSelectableDateRangeOptions.thisMonth:
        dateRange.applyThisMonth();
        break;
      case FinanceSelectableDateRangeOptions.thisQuarter:
        dateRange.applyThisQuarter();
        break;
      case FinanceSelectableDateRangeOptions.thisYear:
        dateRange.applyThisYear();
        break;
      case FinanceSelectableDateRangeOptions.lastYear:
        dateRange.applyLastYear();
        break;
      case FinanceSelectableDateRangeOptions.custom:
        // CAUTIONS: don't change selected date range option to custom with out passing the optional start date and end data
        assert(customStartDate != null && customEndDate != null);
        dateRange.applyCustomDate(customStartDate!, customEndDate!);
        break;
    }
  }
}
