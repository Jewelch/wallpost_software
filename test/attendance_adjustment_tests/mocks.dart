class Mocks {
  static Map<String, dynamic> attendanceListResponse = {
    "data": [
      {
        "id": "401",
        "company_id": 15,
        "attendance_id": "mua8lqhCQE6SyIz",
        "date": "2022-01-28",
        "adjusted_status": "PRESENT",
        "punch_in_time": "09:00",
        "punch_out_time": "06:00",
        "orig_punch_in_time": null,
        "orig_punch_out_time": null,
        "reason": "forgot to punch",
        "approval_status": "Pending",
        "approver_name": "Jayden Mathew"
      },
      {
        "id": "402",
        "company_id": 15,
        "attendance_id": "c8VDE2Scvd9lilI",
        "date": "2022-01-25",
        "adjusted_status": "PRESENT",
        "punch_in_time": "10:15",
        "punch_out_time": "06:00",
        "orig_punch_in_time": null,
        "orig_punch_out_time": null,
        "reason": "forget",
        "approval_status": "Pending",
        "approver_name": "Jayden Mathew"
      },
      {
        "id": "403",
        "company_id": 15,
        "attendance_id": "nnIalwBedW3U4Wg",
        "date": "2022-01-24",
        "adjusted_status": "PRESENT",
        "punch_in_time": "08:00",
        "punch_out_time": "03:00",
        "orig_punch_in_time": null,
        "orig_punch_out_time": null,
        "reason": "kkkkkkkkkkkkkkkkkkkk",
        "approval_status": "Pending",
        "approver_name": "Jayden Mathew"
      },
      {
        "id": "404",
        "company_id": 15,
        "attendance_id": "GAlgrqH5NsHqLaH",
        "date": "2022-01-21",
        "adjusted_status": "EARLYLEAVE",
        "punch_in_time": "11:00",
        "punch_out_time": "15:30",
        "orig_punch_in_time": null,
        "orig_punch_out_time": null,
        "reason": "llllll",
        "approval_status": "Pending",
        "approver_name": "Jayden Mathew"
      },
      {
        "attendance_id": null,
        "date": "2022-01-03",
        "work_status": "ABSENT",
        "punch_in_time": null,
        "punch_out_time": null,
        "reason": null,
        "approval_status": "null"
      }
    ],
  };

  static Map<String, dynamic> attendanceListItemResponse = {
    "id": null,
    "company_id": 42,
    "attendance_id": "Q8pyUr23o8kuGJw",
    "date": "2022-01-28",
    "adjusted_status": "PRESENT",
    "punch_in_time": "08:47",
    "punch_out_time": "18:00",
    "orig_punch_in_time": "08:47",
    "orig_punch_out_time": "18:00",
    "reason": null,
    "approval_status": "null",
    "approver_name": "null"
  };

  static var submitAdjustmentHeader = [
    {
      "id": null,
      "company_id": 15,
      "attendance_id": "qpxroNBXQKgL7QW",
      "date": "2022-01-31",
      "adjusted_status": "PRESENT",
      "punch_in_time": "09:05",
      "punch_out_time": "17:30",
      "orig_punch_in_time": "11:05",
      "orig_punch_out_time": "11:13",
      "reason": "reasonnnn",
      "approval_status": "null",
      "approver_name": "null",
      "edit_mode": false,
      "punch_in_time_error": false,
      "punch_out_time_error": false,
      "status_out_error": false,
      "attnce_reason_error": false,
      "employee_id": 1254,
      "work_status": "PRESENT",
      "adjusted_punchin": "9:05",
      "adjusted_punchout": "17:30"
    }
  ];
}
