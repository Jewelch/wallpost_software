import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';

DateRange getDifferentDateRangeOption(DateRange oldDateRangeFilters) {
  DateRange newDateFilter = DateRange();
  if (SelectableDateRangeOptions.thisYear == oldDateRangeFilters.selectedRangeOption) {
    newDateFilter.selectedRangeOption = SelectableDateRangeOptions.thisMonth;
  } else {
    newDateFilter.selectedRangeOption = SelectableDateRangeOptions.thisYear;
  }
  return newDateFilter;
}
