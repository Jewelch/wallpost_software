enum ItemSalesReportSortOptions {
  byRevenueLowToHigh,
  byRevenueHighToLow,
  byNameAToZ,
  byNameZToA;

  String toReadableString() {
    switch (this) {
      case byRevenueLowToHigh:
        return "Revenue(Low-High)";
      case byRevenueHighToLow:
        return "Revenue(High-Low)";
      case byNameAToZ:
        return "Name A-Z";
      case byNameZToA:
        return "Name Z-A";
    }
  }
}
