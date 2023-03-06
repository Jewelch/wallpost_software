import 'package:wallpost/_shared/extensions/date_extensions.dart';

enum SelectableDateRangeOptions {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  thisYear,
  lastYear,
  custom;

  String toSelectableString() {
    switch (this) {
      case SelectableDateRangeOptions.today:
        return "Today";
      case SelectableDateRangeOptions.yesterday:
        return "Yesterday";
      case SelectableDateRangeOptions.thisWeek:
        return "This Week";
      case SelectableDateRangeOptions.thisMonth:
        return "This Month";
      case SelectableDateRangeOptions.thisYear:
        return "This Year";
      case SelectableDateRangeOptions.lastYear:
        return "Last Year";
      case SelectableDateRangeOptions.custom:
        return "Custom";
    }
  }

  String toRawString() {
    return this == SelectableDateRangeOptions.custom || this == SelectableDateRangeOptions.thisMonth
        ? 'date_between'
        : this.toSelectableString().replaceAll(' ', '_').toLowerCase();
  }
}

class DateRangeFilters {
  SelectableDateRangeOptions _selectedRangeOption = SelectableDateRangeOptions.today;

  SelectableDateRangeOptions get selectedRangeOption => _selectedRangeOption;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  void setSelectedDateRangeOption(SelectableDateRangeOptions selectableDateRangeOptions,{DateTime? customStartDate,DateTime? customEndDate}) {
    _selectedRangeOption = selectableDateRangeOptions;
    endDate = DateTime.now();
    switch (selectableDateRangeOptions) {
      case SelectableDateRangeOptions.today:
        startDate = DateTime.now();
        break;
      case SelectableDateRangeOptions.yesterday:
        var yesterday = DateTime.now().subtract(Duration(days: 1));
        startDate = yesterday;
        endDate = yesterday;
        break;
      case SelectableDateRangeOptions.thisWeek:
        startDate = _mostRecentMonday(endDate);
        break;
      case SelectableDateRangeOptions.thisMonth:
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      case SelectableDateRangeOptions.thisYear:
        startDate = DateTime(endDate.year, 1, 1);
        break;
      case SelectableDateRangeOptions.lastYear:
        var today = DateTime.now();
        startDate = DateTime(today.year - 1, 1, 1);
        endDate = DateTime(today.year - 1, 12, 31);
        break;
      case SelectableDateRangeOptions.custom:
        // CAUTIONS: don't change selected date range option to custom with out passing the optional start date and end data
        assert(customStartDate != null && customEndDate != null);
        startDate = customStartDate!;
        endDate = customEndDate!;
        break;
    }
  }

  DateTime _mostRecentMonday(DateTime date) => DateTime(date.year, date.month, date.day - (date.weekday - 1));

  DateRangeFilters copy() {
    var copyDateRangeFilter = DateRangeFilters();
    copyDateRangeFilter._selectedRangeOption = selectedRangeOption;
    copyDateRangeFilter.startDate = startDate;
    copyDateRangeFilter.endDate = endDate;
    return copyDateRangeFilter;
  }

  @override
  bool operator ==(Object other) {
    if (other is! DateRangeFilters) return false;
    if (other.selectedRangeOption == SelectableDateRangeOptions.custom) {
      if (other.startDate != startDate || other.endDate != endDate) return false;
      return true;
    }
    return other.selectedRangeOption == selectedRangeOption;
  }

  @override
  int get hashCode => super.hashCode;

  String toReadableString() {
    switch (this.selectedRangeOption) {
      case SelectableDateRangeOptions.today:
        return "Today";
      case SelectableDateRangeOptions.yesterday:
        return "Yesterday";
      case SelectableDateRangeOptions.thisWeek:
        return "This Week";
      case SelectableDateRangeOptions.thisMonth:
        return "This Month";
      case SelectableDateRangeOptions.thisYear:
        return "This Year";
      case SelectableDateRangeOptions.lastYear:
        return "Last Year";
      case SelectableDateRangeOptions.custom:
        return startDate.toReadableStringWithHyphens() + " to " + endDate.toReadableStringWithHyphens();
    }
  }
}
