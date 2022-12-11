import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_as_category_model.dart';

import '../../mocks.dart';

void main() {
  test('SalesAsCategories model serialization succeeds when data is valid', () {
    int categoryId = 1;
    String categoryName = 'Tamias';
    num totalQuantity = 124;
    num totalRevenue = 343;

    final salesData = SalesAsCategoriesModel.fromJson(Mocks.specificSalesAsCategoryResponse(
      categoryId: categoryId,
      categoryName: categoryName,
      totalQuantity: totalQuantity,
      totalRevenue: totalRevenue,
    ));

    expect(salesData.categoryId, categoryId);
    expect(salesData.categoryName, categoryName);
    expect(salesData.totalQuantity, totalQuantity);
  });
}
