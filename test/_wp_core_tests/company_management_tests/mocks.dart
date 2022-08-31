class Mocks {
  static Map<String, dynamic> companyMap = {
    "approval_count": 8,
    "company_info": {
      "company_id": 13,
      "account_no": 123123,
      "company_name": "Smart Management - Qatar",
      "short_name": "Smart Management - Qatar",
      "commercial_name": "Smart Management - Qatar",
      "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
      "js_date_format": "yyyy-mm-dd",
      "currency": "USD",
      "packages": ["hr", "task", "timesheet"],
      "is_trial": true,
    },
    "employee": {
      "employment_id": "gEBrqqLflxXRNQT",
      "name": "Obaid Mohamed",
      "designation": "IOS Developer",
      "email_id_office": "mahmed@wallpostsoftware.com",
      "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
      "employment_id_v1": 2123,
      "line_manager": "Ishaque Sethikunhi Ameen",
      "Roles": ["task_line_manager"],
    },
    "request_items": [
      {
        "display_name": "Disciplinary Action",
        "name": "disciplinary_request",
        "sub_module": "disciplinary_action",
        "visibility": true
      },
      {
        "display_name": "Employment Certificate",
        "name": "time_off_request",
        "sub_module": "time_off",
        "visibility": true
      },
      {
        "display_name": "Expense Request",
        "name": "expense_request",
        "sub_module": "expense_request",
        "visibility": true
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
    }
  };
}
