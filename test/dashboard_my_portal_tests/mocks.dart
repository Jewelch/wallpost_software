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
      "currency": "BGN",
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

  static Map<String, dynamic> employeeMyPortalDataResponse = {
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
    "ytd_performance": 80.5,
    "current_month_performance": 23,
    "current_month_attendance_percentage": 96
  };
}
