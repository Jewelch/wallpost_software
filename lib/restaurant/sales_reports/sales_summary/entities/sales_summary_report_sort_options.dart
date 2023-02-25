enum HourlySalesReportSortOptions {
  byRevenueLowToHigh,
  byRevenueHighToLow,
  byTime;

  String toReadableString() {
    switch (this) {
      case byRevenueLowToHigh:
        return "Revenue(Low-High)";
      case byRevenueHighToLow:
        return "Revenue(High-Low)";
      case byTime:
        return "By Time";
    }
  }

  String toRawString() {
    switch (this) {
      case byRevenueLowToHigh:
        return "asc";
      case byRevenueHighToLow:
        return "desc";
      case byTime:
        return 'none';
    }
  }
}
