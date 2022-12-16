import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';

import '../../mocks.dart';

void main() {
  test('ItemSalesDataModel  serialization succeeds when data is valid', () {
    int totalRevenue = 175;
    int totalCategories = 2;
    int totalItemsInAllCategories = 8;
    int totalOfAllItemsQuantities = 22;
    List<Map<String, dynamic>> breakDown = Mocks.itemSalesBreakdownListMock;
    bool isExpanded = true;

    final itemSalesData = ItemSalesDataModel.fromJson(Mocks.specificitemSalesResponse(
      totalRevenue: totalRevenue,
      totalCategories: totalCategories,
      totalItemsInAllCategories: totalItemsInAllCategories,
      totalOfAllItemsQuantities: totalOfAllItemsQuantities,
      breakdown: breakDown,
      isExpanded: isExpanded,
    ));

    expect(itemSalesData.totalRevenue, totalRevenue);
    expect(itemSalesData.totalCategories, totalCategories);
    expect(itemSalesData.totalItemsInAllCategories, totalItemsInAllCategories);
    expect(itemSalesData.totalOfAllItemsQuantities, totalOfAllItemsQuantities);
    expect(itemSalesData.breakdown, Mocks.itemSalesBreakdownList);
  });

  test('ItemSalesDataModel serialization throws a <MappingException> when data is invalid', () {
    try {
      ItemSalesDataModel.fromJson(Mocks.specificitemSalesResponse(
        totalRevenue: "12000",
        totalCategories: 40000,
        totalItemsInAllCategories: 4,
        totalOfAllItemsQuantities: 22,
        breakdown: Mocks.itemSalesBreakdownListMock,
        isExpanded: false,
      ));

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
    try {
      ItemSalesDataModel.fromJson(Mocks.specificitemSalesResponse(
        totalRevenue: 12000,
        totalCategories: "40000",
        totalItemsInAllCategories: 4,
        totalOfAllItemsQuantities: 22,
        breakdown: Mocks.itemSalesBreakdownListMock,
        isExpanded: false,
      ));

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }

    try {
      ItemSalesDataModel.fromJson(Mocks.specificitemSalesResponse(
        totalRevenue: 12000,
        totalCategories: 40000,
        totalItemsInAllCategories: "4",
        totalOfAllItemsQuantities: 22,
        breakdown: Mocks.itemSalesBreakdownListMock,
        isExpanded: false,
      ));

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
    try {
      ItemSalesDataModel.fromJson(Mocks.specificitemSalesResponse(
        totalRevenue: 12000,
        totalCategories: 40000,
        totalItemsInAllCategories: 4,
        totalOfAllItemsQuantities: "22",
        breakdown: Mocks.itemSalesBreakdownListMock,
        isExpanded: false,
      ));

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
    try {
      ItemSalesDataModel.fromJson(Mocks.specificitemSalesResponse(
        totalRevenue: 12000,
        totalCategories: 40000,
        totalItemsInAllCategories: 4,
        totalOfAllItemsQuantities: 22,
        breakdown: "ewqerq fas",
        isExpanded: false,
      ));

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
