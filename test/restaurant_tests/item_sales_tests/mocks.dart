import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';

class Mocks {
  static Map<String, dynamic> itemSalesReportResponse = {
    "totalRevenue": 175,
    "totalCategories": 2,
    "totalItemsInAllCategories": 8,
    "totalOfAllItemsQuantities": 22,
    "breakdown": [
      {
        "categoryId": 1,
        "categoryName": "Soda",
        "totalQuantity": 13,
        "totalRevenue": 61,
        "totalRevenueToDisplay": "61",
        "items": [
          {"itemId": 7, "itemName": "Stewart's", "qty": 2, "revenue": 12, "revenueToDisplay": "12"},
          {"itemId": 6, "itemName": "Mirinda", "qty": 5, "revenue": 25, "revenueToDisplay": "25"},
          {"itemId": 5, "itemName": "Fanta", "qty": 2, "revenue": 10, "revenueToDisplay": "10"},
          {"itemId": 1, "itemName": "Coke", "qty": 2, "revenue": 0, "revenueToDisplay": "0"},
          {"itemId": 8, "itemName": "Mtn Dew Live Wire", "qty": 2, "revenue": 14, "revenueToDisplay": "14"}
        ]
      },
      {
        "categoryId": 2,
        "categoryName": "Salads",
        "totalQuantity": 9,
        "totalRevenue": 114,
        "totalRevenueToDisplay": "114",
        "items": [
          {"itemId": 2, "itemName": "Cesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
          {"itemId": 11, "itemName": "Pasta Salad", "qty": 3, "revenue": 54, "revenueToDisplay": "54"},
          {"itemId": 12, "itemName": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56, "revenueToDisplay": "56"}
        ]
      },
      {
        "categoryId": 3,
        "categoryName": "Aalads",
        "totalQuantity": 9,
        "totalRevenue": 114,
        "totalRevenueToDisplay": "114",
        "items": [
          {"itemId": 2, "itemName": "Aesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
          {"itemId": 2, "itemName": "Cesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
          {"itemId": 2, "itemName": "Besar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
          {"itemId": 11, "itemName": "Pasta Salad", "qty": 3, "revenue": 54, "revenueToDisplay": "54"},
          {"itemId": 12, "itemName": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56, "revenueToDisplay": "56"}
        ]
      },
      {
        "categoryId": 4,
        "categoryName": "Balads",
        "totalQuantity": 9,
        "totalRevenue": 114,
        "totalRevenueToDisplay": "114",
        "items": [
          {"itemId": 2, "itemName": "Cesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
          {"itemId": 11, "itemName": "Pasta Salad", "qty": 3, "revenue": 54, "revenueToDisplay": "54"},
          {"itemId": 12, "itemName": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56, "revenueToDisplay": "56"}
        ]
      }
    ]
  };

// static ItemSalesReport itemSalesResponse = ItemSalesReport.fromJson(itemSalesRandomResponse);
//
// static List<Map<String, dynamic>> itemSalesBreakdownListMock = [
//   {
//     "categoryId": 1,
//     "categoryName": "Soda",
//     "totalQuantity": 13,
//     "totalRevenue": 61,
//     "totalRevenueToDisplay": "61",
//     "items": [
//       {"itemId": 7, "itemName": "Stewart's", "qty": 2, "revenue": 12, "revenueToDisplay": "12"},
//       {"itemId": 6, "itemName": "Mirinda", "qty": 5, "revenue": 25, "revenueToDisplay": "25"},
//       {"itemId": 5, "itemName": "Fanta", "qty": 2, "revenue": 10, "revenueToDisplay": "10"},
//       {"itemId": 1, "itemName": "Coke", "qty": 2, "revenue": 0, "revenueToDisplay": "0"},
//       {"itemId": 8, "itemName": "Mtn Dew Live Wire", "qty": 2, "revenue": 14, "revenueToDisplay": "14"}
//     ]
//   },
//   {
//     "categoryId": 2,
//     "categoryName": "Salads",
//     "totalQuantity": 9,
//     "totalRevenue": 114,
//     "totalRevenueToDisplay": "114",
//     "items": [
//       {"itemId": 2, "itemName": "Cesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
//       {"itemId": 11, "itemName": "Pasta Salad", "qty": 3, "revenue": 54, "revenueToDisplay": "54"},
//       {"itemId": 12, "itemName": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56, "revenueToDisplay": "56"}
//     ]
//   },
// ];
//
// static List<ItemSalesBreakdown>? itemSalesBreakdownList = [
//   ItemSalesBreakdown.fromJson(
//     {
//       "categoryId": 1,
//       "categoryName": "Soda",
//       "totalQuantity": 13,
//       "totalRevenue": 61,
//       "totalRevenueToDisplay": "61",
//       "items": [
//         {"itemId": 7, "itemName": "Stewart's", "qty": 2, "revenue": 12, "revenueToDisplay": "12"},
//         {"itemId": 6, "itemName": "Mirinda", "qty": 5, "revenue": 25, "revenueToDisplay": "25"},
//         {"itemId": 5, "itemName": "Fanta", "qty": 28, "revenue": 10, "revenueToDisplay": "10"},
//         {"itemId": 1, "itemName": "Coke", "qty": 242, "revenue": 0, "revenueToDisplay": "0"},
//         {"itemId": 8, "itemName": "Mtn Dew Live Wire", "qty": 2, "revenue": 14, "revenueToDisplay": "14"}
//       ]
//     },
//   ),
//   ItemSalesBreakdown.fromJson(
//     {
//       "categoryId": 2,
//       "categoryName": "Salads",
//       "totalQuantity": 9,
//       "totalRevenue": 114,
//       "totalRevenueToDisplay": "114",
//       "items": [
//         {"itemId": 2, "itemName": "Cesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
//         {"itemId": 11, "itemName": "Pasta Salad", "qty": 3, "revenue": 54, "revenueToDisplay": "54"},
//         {"itemId": 12, "itemName": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56, "revenueToDisplay": "56"}
//       ]
//     },
//   )
// ];
//
// static Map<String, dynamic> specificItemSalesResponse({
//   required dynamic totalRevenue,
//   required dynamic totalCategories,
//   required dynamic totalItemsInAllCategories,
//   required dynamic totalOfAllItemsQuantities,
//   required dynamic breakdown,
//   required bool isExpanded,
// }) =>
//     {
//       "totalRevenue": totalRevenue,
//       "totalCategories": totalCategories,
//       "totalItemsInAllCategories": totalItemsInAllCategories,
//       "totalOfAllItemsQuantities": totalOfAllItemsQuantities,
//       "breakdown": breakdown,
//       "isExpanded": isExpanded,
//     };

}
