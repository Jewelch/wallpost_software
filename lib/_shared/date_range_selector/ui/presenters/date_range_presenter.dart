import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';

import '../../entities/selectable_date_range_option.dart';

class DateRangePresenter {
  DateRange dateRange = DateRange();

  void onSelectDateRangeOption(SelectableDateRangeOptions selectableDateRangeOptions,
      {DateTime? customStartDate, DateTime? customEndDate}) {
    switch (selectableDateRangeOptions) {
      case SelectableDateRangeOptions.today:
        dateRange.applyToday();
        break;
      case SelectableDateRangeOptions.yesterday:
        dateRange.applyYesterday();
        break;
      case SelectableDateRangeOptions.thisWeek:
        dateRange.applyThisWeek();
        break;
      case SelectableDateRangeOptions.thisMonth:
        dateRange.applyThisMonth();
        break;
      case SelectableDateRangeOptions.thisQuarter:
        dateRange.applyThisQuarter();
        break;
      case SelectableDateRangeOptions.thisYear:
        dateRange.applyThisYear();
        break;
      case SelectableDateRangeOptions.lastYear:
        dateRange.applyLastYear();
        break;
      case SelectableDateRangeOptions.custom:
        // CAUTIONS: don't change selected date range option to custom with out passing the optional start date and end data
        assert(customStartDate != null && customEndDate != null);
        dateRange.applyCustomDate(customStartDate!, customEndDate!);
        break;
    }
  }
}
