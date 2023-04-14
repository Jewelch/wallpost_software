class Mocks {
  static Map<String, dynamic> financialDashboardResponse = {
    "profit_and_loss": "-5,991,721,466",
    "income": "8,410,392",
    "expenses": "3,736,625",
    "bank_and_cashe": "-123,427,924,745,639",
    "cashe_in": "34,940",
    "cashe_out": "123,387,989,914,483",
    "chart_data": {
      "months": ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"],
      "cache_in": ["5,000", "7,837", "18,603", "3,500", "0", "0", "0", "0", "0", "0", "0", "0"],
      "cache_out": ["0", "12,859", "123,387,989,900,536", "0", "0", "0", "0", "0", "0", "1,088", "0", "0"]
    },
    "invoice_report": {
      "overdue": "558,204,588",
      "currrent_due": "10,090",
      "invoiced": "562,157,535",
      "collected": "525,433"
    },
    "bill_report": {
      "overdue": "124,662,473,536",
      "current_due": "10,090",
      "billed": "164,663,328,151",
      "paid": "40,000,905,076"
    }
  };
}
