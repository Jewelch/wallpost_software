import 'package:wallpost/_shared/extensions/date_extensions.dart';

import 'inventory_stock_warehouse.dart';

class InventoryStockReportFilter {
  DateTime date = DateTime.now();
  InventoryStockWarehouse? warehouse;
  String searchText = "";

  InventoryStockReportFilter copy() {
    var newFilter = InventoryStockReportFilter();
    newFilter.date = this.date;
    newFilter.warehouse = this.warehouse;
    newFilter.searchText = this.searchText;
    return newFilter;
  }

  String getDateFilterTitle() {
    if (date.isToday()) {
      return "Today";
    } else {
      return date.toReadableString();
    }
  }

  String getWarehouseFilterTitle() {
    if (warehouse == null) {
      return "Warehouse: All";
    } else {
      return warehouse!.name;
    }
  }
}
