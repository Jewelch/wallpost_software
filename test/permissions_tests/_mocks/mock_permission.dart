import 'package:mocktail/mocktail.dart';
import 'package:wallpost/permission/entities/permissions.dart';

class MockPermission extends Mock implements Permissions {}

var requestItemsListResponse = [
  {
    "display_name": "Task",
    "name": "myportal_create_task",
    "sub_module": "myportal_create_task",
    "visibility": true
  },
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
  },
  {
    "display_name": "Experience Certificate",
    "name": "experience_certificate_request",
    "sub_module": "payroll",
    "visibility": true
  },
  {
    "display_name": "Item Request",
    "name": "item_request",
    "sub_module": "item_request",
    "visibility": true
  },
  {
    "display_name": "Leave Encashment",
    "name": "leave_encashment",
    "sub_module": "leave_encashment",
    "visibility": true
  },
  {
    "display_name": "Leave Request",
    "name": "leave_request",
    "sub_module": "leave",
    "visibility": true
  },
  {
    "display_name": "Letter to Obtain Visa",
    "name": "obtain_visa_request",
    "sub_module": "obtain_visa_request",
    "visibility": true
  },
  {
    "display_name": "Loan",
    "name": "loan_request",
    "sub_module": "salary_advance_loan",
    "visibility": true
  },
  {
    "display_name": "Manpower Outsourcing",
    "name": "punch_in_out",
    "sub_module": "punch_in_out",
    "visibility": false
  },
  {
    "display_name": "Overtime Request",
    "name": "overtime_request",
    "sub_module": "overtime_request",
    "visibility": true
  },
  {
    "display_name": "Punch In/Out Outside Office",
    "name": "punch_in_out",
    "sub_module": "attendance",
    "visibility": true
  },
  {
    "display_name": "Resignation Request",
    "name": "resignation_request",
    "sub_module": "end_of_service",
    "visibility": true
  },
  {
    "display_name": "Salary Advance",
    "name": "salary_advance_loan",
    "sub_module": "salary_advance_loan",
    "visibility": true
  },
  {
    "display_name": "Salary Certificate",
    "name": "salary_certificate_request",
    "sub_module": "payroll",
    "visibility": true
  },
  {
    "display_name": "Secondment Request",
    "name": "secondment_request",
    "sub_module": "secondment",
    "visibility": true
  },
  {
    "display_name": "Support Ticket",
    "name": "support_ticket",
    "sub_module": "support_ticket",
    "visibility": true
  },
  {
    "display_name": "Termination Request",
    "name": "termination_request",
    "sub_module": "end_of_service",
    "visibility": true
  },
  {
    "display_name": "Time Off",
    "name": "time_off_request",
    "sub_module": "time_off",
    "visibility": true
  },
  {
    "display_name": "Timesheet Adjustment",
    "name": "timesheet_adjustment",
    "sub_module": "timesheet",
    "visibility": true
  }
];
