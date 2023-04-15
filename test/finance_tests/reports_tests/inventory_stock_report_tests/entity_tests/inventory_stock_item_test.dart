import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_item.dart';

import '../mocks.dart';

void main() {
  test("stock quantities", () {
    var itemMap = Mocks.inventoryStockReportResponse["items"][0];

    itemMap["quantity"] = "-10";
    var item = InventoryStockItem.fromJson(itemMap);
    expect(item.isStockNegative(), true);
    expect(item.isStockZero(), false);

    itemMap["quantity"] = "0";
    item = InventoryStockItem.fromJson(itemMap);
    expect(item.isStockNegative(), false);
    expect(item.isStockZero(), true);
  });
}
