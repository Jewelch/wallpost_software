enum FinanceSelectableDateRangeOptions {
  thisMonth,
  thisQuarter,
  thisYear,
  lastYear,
  custom;

  String toSelectableString() {
    switch (this) {
      case FinanceSelectableDateRangeOptions.thisMonth:
        return "This Month";
      case FinanceSelectableDateRangeOptions.thisQuarter:
        return "This Quarter";
      case FinanceSelectableDateRangeOptions.thisYear:
        return "This Year";
      case FinanceSelectableDateRangeOptions.lastYear:
        return "Last Year";
      case FinanceSelectableDateRangeOptions.custom:
        return "Custom";
    }
  }
}
