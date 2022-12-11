import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_as_item_model.dart';

import '../../mocks.dart';

void main() {
  test('SalesAsItem model serialization succeeds when data is valid', () {
    int itemId = 1;
    String itemName = 'Burger';
    num qty = 12;
    num revenue = 34;

    final salesItemData = SalesAsItemModel.fromJson(Mocks.specificSalesAsItemResponse(
      itemId: itemId,
      itemName: itemName,
      qty: qty,
      revenue: revenue,
    ));

    expect(salesItemData.itemId, itemId);
    expect(salesItemData.itemName, itemName);
    expect(salesItemData.qty, qty);
    expect(salesItemData.revenue, revenue);
  });
}
