import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../entities/inventory_stock_warehouse.dart';

class InventoryStockReportUrls {
  static String inventoryStockReportUrl({
    required String companyId,
    required DateTime date,
    String? searchText,
    InventoryStockWarehouse? warehouse,
    required int pageNumber,
    required int itemsPerPage,
  }) {
    var url = "${BaseUrls.hrUrlV3()}/companies/$companyId/finance/inventory/stock_report?";
    url += "date=${date.yyyyMMddString()}";
    if (searchText != null && searchText.isNotEmpty) url += "&search=$searchText";
    if (warehouse != null) url += "&warehouse=${warehouse.id}";
    url += "&page=$pageNumber&perPage=$itemsPerPage&consumedByMobile=true";
    return url;
  }

  static String inventoryWarehouseUrl(String companyId) {
    return "${BaseUrls.miscUrlV2()}/crm/companies/$companyId/warehouses";
  }
}
