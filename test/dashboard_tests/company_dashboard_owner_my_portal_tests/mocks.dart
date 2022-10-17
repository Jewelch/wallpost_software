class Mocks {
  static Map<String, dynamic> ownerMyPortalDataResponse = {
    "aggregated_approvals": [
      {
        "comapnyId": 3,
        "companyName": "AB_Real Estate",
        "approvalType": "Leave Request",
        "module": "hr",
        "moduleId": "hr",
        "moduleColor": "#f2b33d",
        "approvalCount": 8
      },
      {
        "comapnyId": 3,
        "companyName": "AB_Real Estate",
        "approvalType": "Expense Request",
        "module": "hr",
        "moduleId": "hr",
        "moduleColor": "#f2b33d",
        "approvalCount": 4
      }
    ],
    "financial_summary": {
      "actual_revenue_display": "0",
      "overall_revenue": 0,
      "cashAvailability": "9.9M",
      "receivableOverdue": "32.3K",
      "payableOverdue": "67.3K",
      "profitLoss": "14.7K",
      "profitLossPerc": "51.854325587935"
    },
    "company_performance": 80.5,
    "absentees": 23
  };

  static Map<String, dynamic> crmDashboardDataResponse = {
    "actual_revenue": "13,000",
    "target_achieved_percentage": 12,
    "in_pipeline": "140",
    "lead_converted_percentage": 20
  };

  static Map<String, dynamic> hrDashboardDataResponse = {
    "active_staff": "1,234",
    "employee_cost": "1,234,222",
    "staff_on_leave": "24",
    "documents_expired": "30"
  };

  static Map<String, dynamic> restaurantDashboardDataResponse = {
    "at_a_glance_sales_amount": "1,233,000",
    "filtered_sales_amount": "12,333,000",
  };

  static Map<String, dynamic> retailDashboardDataResponse = {
    "at_a_glance_sales_amount": "1,233,000",
    "filtered_sales_amount": "12,333,000",
  };
}
