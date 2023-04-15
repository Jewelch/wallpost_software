class Mocks {
  static Map<String, dynamic> inventoryStockReportResponse = {
    "total": "200",
    "items": [
      {
        "id": "1476",
        "name": "Black pepper",
        "code": "OS-BP01",
        "unit": "kg",
        "quantity": "20",
        "cost": "5",
        "total_cost": "100"
      },
      {
        "id": "1477",
        "name": "Red pepper",
        "code": "OS-RP02",
        "unit": "kg",
        "quantity": "20",
        "cost": "5",
        "total_cost": "100"
      }
    ]
  };

  static Map<String, dynamic> inventoryStockReportResponsePage2 = {
    "total": "300",
    "items": [
      {
        "id": "111",
        "name": "New",
        "code": "OS-BP01",
        "unit": "kg",
        "quantity": "20",
        "cost": "5",
        "total_cost": "100",
      },
    ]
  };

  static List<Map<String, dynamic>> warehouseListResponse = [
    {"id": 1, "name": "name1"},
    {"id": 2, "name": "name2"},
    {"id": 3, "name": "name3"},
    {"id": 4, "name": "name4"},
  ];
}
