class Mocks {
  static Map<String, dynamic> crmDashboardResponse = {
    "sales_this_year": {
      "budgeted_revenue": "1,197,109",
      "actual_revenue": "2,475,210",
      "target_achieved_percentage": "48",
      "in_pipeline": "34,560"
    },
    "sales_growth_this_year": {"lead_conversion": 67, "sales_growth": "-100"},
    "staff_performance": [
      {
        "salesman": 458,
        "title": "",
        "photo": "",
        "photo_url": "www.url.com",
        "salesman_name": "Lalu E K",
        "target_amount": 0,
        "actual_amount": "0",
        "percentage": 0,
        "active": "1"
      },
      {
        "salesman": 255,
        "title": "",
        "photo": "DOC_ad9ae959-db0a-40f4-8759-8a5a24805b8e.jpg",
        "photo_url": "www.url.com",
        "salesman_name": "Mark Smith",
        "target_amount": 0,
        "actual_amount": "6.4K",
        "percentage": 0,
        "active": "1"
      },
    ],
    "service_performance": [
      {"id": -1, "name": "Tamias Retail", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": -2, "name": "Tamias Restaurant", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "4", "name": "Audit", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "5", "name": "Advisory", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "6", "name": "Bookkeeping", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "7", "name": "HR Service", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "8", "name": "ERP", "actual": "6.4K", "target": "0", "achievment_percentage": 0},
      {"id": "9", "name": "Manpower Outsourcing", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "10", "name": "Recruitment", "actual": "0", "target": "0", "achievment_percentage": 0},
      {"id": "14", "name": "Payroll", "actual": "0", "target": "0", "achievment_percentage": 0}
    ]
  };
}
