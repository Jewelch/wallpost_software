enum HourlySalesReportSortOptions {
  byRevenueLowToHigh,
  byRevenueHighToLow;

  String toReadableString() {
    switch (this) {
      case byRevenueLowToHigh:
        return "Revenue(Low-High)";
      case byRevenueHighToLow:
        return "Revenue(High-Low)";
    }
  }

  String toRawString() {
    switch (this) {
      case byRevenueLowToHigh:
        return "asc";
      case byRevenueHighToLow:
        return "desc";
    }
  }
}
