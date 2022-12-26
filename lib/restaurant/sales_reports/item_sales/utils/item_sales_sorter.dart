import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';

class ItemSalesSorter {
  ItemSalesDataModel sortBreakDowns(ItemSalesDataModel itemSalesDataModel, ItemSalesReportSortOptions sortOptions) {
    var breakdowns = itemSalesDataModel.breakdown ?? [];
    switch (sortOptions) {
      case ItemSalesReportSortOptions.byRevenueLowToHigh:
        breakdowns.forEach((breakdown) {
          (breakdown.items ?? []).sort((a, b) => a.revenue!.compareTo(b.revenue!));
        });
        breakdowns.sort((a, b) => a.totalRevenue!.compareTo(b.totalRevenue!));
        return itemSalesDataModel;
      case ItemSalesReportSortOptions.byRevenueHighToLow:
        breakdowns.forEach((breakdown) {
          (breakdown.items ?? []).sort((a, b) => a.revenue!.compareTo(b.revenue!));
          breakdown.items = breakdown.items!.reversed.toList();
        });
        breakdowns.sort((a, b) => a.totalRevenue!.compareTo(b.totalRevenue!));
        itemSalesDataModel.breakdown = itemSalesDataModel.breakdown!.reversed.toList();
        return itemSalesDataModel;
      case ItemSalesReportSortOptions.byNameAToZ:
        breakdowns.forEach((breakdown) {
          (breakdown.items ?? []).sort((a, b) => a.itemName!.compareTo(b.itemName!));
        });
        breakdowns.sort((a, b) => a.categoryName!.compareTo(b.categoryName!));
        return itemSalesDataModel;
      case ItemSalesReportSortOptions.byNameZToA:
        breakdowns.forEach((breakdown) {
          (breakdown.items ?? []).sort((a, b) => a.itemName!.compareTo(b.itemName!));
          breakdown.items = breakdown.items!.reversed.toList();
        });
        breakdowns.sort((a, b) => a.categoryName!.compareTo(b.categoryName!));
        itemSalesDataModel.breakdown = itemSalesDataModel.breakdown!.reversed.toList();
        return itemSalesDataModel;
    }
  }

  List<ItemSales> sortAllBreakDownItems(ItemSalesDataModel itemSalesDataModel, ItemSalesReportSortOptions sortOptions) {
    var itemsList = <ItemSales>[];
    itemSalesDataModel.breakdown?.forEach((element) => element.items?.forEach((item) => itemsList.add(item)));
    switch (sortOptions) {
      case ItemSalesReportSortOptions.byRevenueLowToHigh:
        itemsList.sort((a, b) => a.revenue!.compareTo(b.revenue!));
        return itemsList;
      case ItemSalesReportSortOptions.byRevenueHighToLow:
        itemsList.sort((a, b) => a.revenue!.compareTo(b.revenue!));
        itemsList = itemsList.reversed.toList();
        return itemsList;
      case ItemSalesReportSortOptions.byNameAToZ:
        itemsList.sort((a, b) => a.itemName!.compareTo(b.itemName!));
        return itemsList;
      case ItemSalesReportSortOptions.byNameZToA:
        itemsList.sort((a, b) => a.itemName!.compareTo(b.itemName!));
        itemsList = itemsList.reversed.toList();
        return itemsList;
    }
  }
}
