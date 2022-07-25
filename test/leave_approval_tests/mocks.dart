class Mocks {
  static Map<String, dynamic> leaveApprovalListResponse = {
    "count": {
      "pending": 43,
      "approved": 156,
      "rejected": 23,
      "leave_types": {
        "all_leaves": 43,
        "sick_leave": {"id": 4, "name": "Sick Leave ", "count": 22},
        "sick_leave_injuery": {"id": 5, "name": "Sick Leave Injuery", "count": 0},
        "shared_paternal": {"id": 6, "name": "Shared Paternal", "count": 2},
        "maternity_leave": {"id": 7, "name": "Maternity Leave", "count": 0},
        "business_trip": {"id": 9, "name": "Business Trip", "count": 3},
        "hajj_leave": {"id": 13, "name": "Hajj Leave", "count": 2},
        "annual_vaccation": {"id": 91, "name": "Annual Vaccation", "count": 1},
        "adoption_leave": {"id": 107, "name": "Adoption Leave", "count": 0},
        "paternity_leave": {"id": 118, "name": "Paternity Leave", "count": 1},
        "casual_leave": {"id": 158, "name": "Casual Leave", "count": 11},
        "sick_leave_1": {"id": 165, "name": "Sick LEAVE 1", "count": 1}
      }
    },
    "detail": [
      {
        "id": 1463,
        "auto_number": "22/01463",
        "leave_days": 1,
        "leave_from": "Mar/02/2022",
        "leave_to": "Mar/02/2022",
        "status": 2,
        "attach_doc": [],
        "origin": null,
        "destination": null,
        "leave_type_id": 91,
        "created_on": "Jan/03/2022",
        "approve_request_by": "Arvi  Wrestle",
        "decision_status": "rejected",
        "reject_message": "df",
        "leave_type": {
          "id": 91,
          "name": "Annual Vaccation",
          "handover_status": "1",
          "clearance_status": 1,
          "payment_cheque_type": "1"
        }
      },
      {
        "id": 1462,
        "auto_number": "22/01462",
        "leave_days": 1,
        "leave_from": "Jan/03/2022",
        "leave_to": "Jan/03/2022",
        "status": 2,
        "attach_doc": [],
        "origin": null,
        "destination": null,
        "leave_type_id": 91,
        "created_on": "Jan/03/2022",
        "approve_request_by": "Arvi  Wrestle",
        "decision_status": "rejected",
        "reject_message": "swr",
        "leave_type": {
          "id": 91,
          "name": "Annual Vaccation",
          "handover_status": "1",
          "clearance_status": 1,
          "payment_cheque_type": "1"
        }
      },
      {
        "id": 1448,
        "auto_number": "21/01448",
        "leave_days": 2,
        "leave_from": "Nov/03/2021",
        "leave_to": "Nov/04/2021",
        "status": 2,
        "attach_doc": [],
        "origin": null,
        "destination": null,
        "leave_type_id": 165,
        "created_on": "Nov/18/2021",
        "approve_request_by": "Manyata  Gosh",
        "decision_status": "rejected",
        "reject_message": "66",
        "leave_type": {
          "id": 165,
          "name": "Sick LEAVE 1",
          "handover_status": "0",
          "clearance_status": 1,
          "payment_cheque_type": "1"
        }
      },
      {
        "id": 1447,
        "auto_number": "21/01447",
        "leave_days": 5,
        "leave_from": "Nov/02/2021",
        "leave_to": "Nov/06/2021",
        "status": 2,
        "attach_doc": [],
        "origin": null,
        "destination": null,
        "leave_type_id": 165,
        "created_on": "Nov/18/2021",
        "approve_request_by": "Onboarding  Activity",
        "decision_status": "rejected",
        "reject_message": "not applicable",
        "leave_type": {
          "id": 165,
          "name": "Sick LEAVE 1",
          "handover_status": "0",
          "clearance_status": 1,
          "payment_cheque_type": "1"
        }
      },
      {
        "id": 1445,
        "auto_number": "21/01445",
        "leave_days": 3,
        "leave_from": "Nov/08/2021",
        "leave_to": "Nov/11/2021",
        "status": 2,
        "attach_doc": [],
        "origin": null,
        "destination": null,
        "leave_type_id": 158,
        "created_on": "Nov/18/2021",
        "approve_request_by": "Neha  Gupta",
        "decision_status": "rejected",
        "reject_message": "not applicable",
        "leave_type": {
          "id": 158,
          "name": "Casual Leave",
          "handover_status": "0",
          "clearance_status": 1,
          "payment_cheque_type": "1"
        }
      },
    ]
  };
}
