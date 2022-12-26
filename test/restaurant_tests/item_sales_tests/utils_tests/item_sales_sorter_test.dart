import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/utils/item_sales_sorter.dart';

import '../../mocks.dart';

main() {
  var itemSalesSorter = ItemSalesSorter();

  // MARK: Sort by Name A to Z

  test("sort all category with item data by a to z", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var newItemSalesData = itemSalesSorter.sortBreakDowns(itemSalesData, ItemSalesReportSortOptions.byNameAToZ);

    var comparedCategoryName;
    for (var category in newItemSalesData.breakdown!) {
      var currentString = category.categoryName;
      if (comparedCategoryName != null) {
        expect(comparedCategoryName.compareTo(currentString) <= 0, true);
      }
      comparedCategoryName = currentString;
    }

    var comparedItemName;
    for (var category in newItemSalesData.breakdown!) {
      for (var item in category.items ?? []) {
        var currentString = item.itemName;
        if (comparedItemName != null) {
          expect(comparedItemName.compareTo(currentString) <= 0, true);
        }
        comparedItemName = currentString;
      }
      comparedItemName = null;
    }
  });

  test("sort all items by a to z", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var allItems = itemSalesSorter.sortAllBreakDownItems(itemSalesData, ItemSalesReportSortOptions.byNameAToZ);

    var comparedItemName;
    for (var item in allItems) {
      var currentString = item.itemName;
      if (comparedItemName != null) {
        expect(comparedItemName.compareTo(currentString) <= 0, true);
      }
      comparedItemName = currentString;
    }
  });


  // MARK: Sort by Name Z to A

  test("sort all category with item data by z to a", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var newItemSalesData = itemSalesSorter.sortBreakDowns(itemSalesData, ItemSalesReportSortOptions.byNameZToA);

    var comparedCategoryName;
    for (var category in newItemSalesData.breakdown!) {
      var currentName = category.categoryName;
      if (comparedCategoryName != null) {
        expect(comparedCategoryName.compareTo(currentName) >= 0, true);
      }
      comparedCategoryName = currentName;
    }

    var comparedItemName;
    for (var category in newItemSalesData.breakdown!) {
      for (var item in category.items ?? []) {
        var currentName = item.itemName;
        if (comparedItemName != null) {
          expect(comparedItemName.compareTo(currentName) >= 0, true);
        }
        comparedItemName = currentName;
      }
      comparedItemName = null;
    }
  });

  test("sort all items by z to a", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var allItems = itemSalesSorter.sortAllBreakDownItems(itemSalesData, ItemSalesReportSortOptions.byNameZToA);

    var comparedItemName;
    for (var item in allItems) {
      var currentName = item.itemName;
      if (comparedItemName != null) {
        expect(comparedItemName.compareTo(currentName) >= 0, true);
      }
      comparedItemName = currentName;
    }
  });


  // MARK: Sort by revenue low to high

  test("sort all category with item data by revenue low to high", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var newItemSalesData = itemSalesSorter.sortBreakDowns(itemSalesData, ItemSalesReportSortOptions.byRevenueLowToHigh);

    var comparedCategoryRevenue;
    for (var category in newItemSalesData.breakdown!) {
      var currentRevenue = category.totalRevenue;
      if (comparedCategoryRevenue != null) {
        expect(comparedCategoryRevenue.compareTo(currentRevenue) <= 0, true);
      }
      comparedCategoryRevenue = currentRevenue;
    }

    var comparedItemRevenue;
    for (var category in newItemSalesData.breakdown!) {
      for (var item in category.items ?? []) {
        var currentRevenue = item.revenue;
        if (comparedItemRevenue != null) {
          expect(comparedItemRevenue.compareTo(currentRevenue) <= 0, true);
        }
        comparedItemRevenue = currentRevenue;
      }
      comparedItemRevenue = null;
    }
  });

  test("sort all items revenue low to high", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var allItems = itemSalesSorter.sortAllBreakDownItems(itemSalesData, ItemSalesReportSortOptions.byRevenueLowToHigh);

    var comparedItemRevenue;
    for (var item in allItems) {
      var currentRevenue = item.revenue;
      if (comparedItemRevenue != null) {
        expect(comparedItemRevenue.compareTo(currentRevenue) <= 0, true);
      }
      comparedItemRevenue = currentRevenue;
    }
  });



  // MARK: Sort by revenue high to low

  test("sort all category with item data by revenue high to low", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var newItemSalesData = itemSalesSorter.sortBreakDowns(itemSalesData, ItemSalesReportSortOptions.byRevenueHighToLow);

    var comparedCategoryRevenue;
    for (var category in newItemSalesData.breakdown!) {
      var currentRevenue = category.totalRevenue;
      if (comparedCategoryRevenue != null) {
        expect(comparedCategoryRevenue.compareTo(currentRevenue) >= 0, true);
      }
      comparedCategoryRevenue = currentRevenue;
    }

    var comparedItemRevenue;
    for (var category in newItemSalesData.breakdown!) {
      for (var item in category.items ?? []) {
        var currentRevenue = item.revenue;
        if (comparedItemRevenue != null) {
          expect(comparedItemRevenue.compareTo(currentRevenue) >= 0, true);
        }
        comparedItemRevenue = currentRevenue;
      }
      comparedItemRevenue = null;
    }
  });

  test("sort all items revenue high to low", () {
    var itemSalesData = ItemSalesDataModel.fromJson(Mocks.itemSalesRandomResponse);

    var allItems = itemSalesSorter.sortAllBreakDownItems(itemSalesData, ItemSalesReportSortOptions.byRevenueHighToLow);

    var comparedItemRevenue;
    for (var item in allItems) {
      var currentRevenue = item.revenue;
      if (comparedItemRevenue != null) {
        expect(comparedItemRevenue.compareTo(currentRevenue) >= 0, true);
      }
      comparedItemRevenue = currentRevenue;
    }
  });
}
