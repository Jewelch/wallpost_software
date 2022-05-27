class Mocks {
  static List<dynamic> approvalsResponse = [
    {
      "approvalType": "leaveApproval",
      "id": 865,
      "company_id": 15,
      "company_name": "Business +",
      "details": {
        "auto_number": "19/00865",
        "employee_id": 164,
        "leave_days": 1,
        "leave_from": "2019.02.03",
        "leave_to": "2019.02.03",
        "status": 0,
        "attach_doc": "",
        "origin": null,
        "destination": null,
        "created_on": "2019.02.04",
        "approve_request_by": "John  Mathew",
        "decision_status": "pending",
        "reject_message": null
      }
    }
  ];

  static Map<String, Object> approvalsMetaDataResponse = {
      "total": 55,
      "per_page": "10",
      "current_page": 4,
      "last_page": 6,
      "next_page_url": "/?page=5",
      "prev_page_url": "/?page=3",
      "from": 31,
      "to": 40
  };
}
