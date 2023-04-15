import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_report_filter.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';

class MockWarehouse extends Mock implements InventoryStockWarehouse {}

void main() {
  test("defaults", () {
    var filters = InventoryStockReportFilter();

    expect(filters.date.isToday(), true);
    expect(filters.warehouse, null);
    expect(filters.searchText, "");
  });

  test("get date filter title", () {
    var filters = InventoryStockReportFilter();

    filters.date = DateTime.now();
    expect(filters.getDateFilterTitle(), "Today");

    filters.date = DateTime(2002, 11, 23);
    expect(filters.getDateFilterTitle(), "23 Nov 2002");
  });

  test("get warehouse filter title", () {
    var filters = InventoryStockReportFilter();

    filters.warehouse = null;
    expect(filters.getWarehouseFilterTitle(), "Warehouse: All");

    var warehouse = MockWarehouse();
    when(() => warehouse.name).thenReturn("some warehouse");
    filters.warehouse = warehouse;
    expect(filters.getWarehouseFilterTitle(), "some warehouse");
  });
}
