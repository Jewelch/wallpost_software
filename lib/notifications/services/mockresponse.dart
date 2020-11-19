class MockResponse {
  static var pageOneResponse = [
    // {
    //   "notification_id": 122194,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "0",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "o3ML1JwhMoM3VKX",
    //     "title": "Shovest Flutter Sprint 11",
    //     "body":
    //         "A New Task has been assigned to you, created by You and approved by Ishaque Sethikunhi Ameen - Technical Manager  ",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-11-09 12:34:43",
    //   "resourse_info": {
    //     "task_name": "Shovest Flutter Sprint 11",
    //     "created_by": "Obaid Mohamed",
    //     "status": "New"
    //   }
    // },
    // {
    //   "notification_id": 121838,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4443",
    //     "title": "Leave Request Approval",
    //     "body": "From Safi  Ahmed",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-11-02 01:03:02",
    //   "resourse_info": {
    //     "applicant": "Safi Ahmed",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-01",
    //     "leaveTo": "2020-11-01"
    //   }
    // },
    // {
    //   "notification_id": 121434,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "1G1Ax2hx7E50xjc",
    //     "title":
    //         "Task : ShovestClub Flutter Refactor - Shops List - Completion Approval Request",
    //     "body":
    //         "Please be informed that Task Shovest Club Flutter Refactor - Shops List has been completed  \n        by Safi Ahmed and require your approval as the line manager.Please review the request and take necessary action in 3 working days else system will consider the task as approval delayed against you and escalate to your line Manager Ishaque Sethikunhi Ameen.Completion Comment: Completed.",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-10-26 01:28:24",
    //   "resourse_info": {
    //     "task_name": "Shovest Club Flutter Refactor - Shops List",
    //     "created_by": "Safi Ahmed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 121309,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4421",
    //     "title": "Leave Request Approval",
    //     "body": "From Saeed  Gosalaparamban",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-10-23 04:34:05",
    //   "resourse_info": {
    //     "applicant": "Saeed  Gosalaparamban",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-02",
    //     "leaveTo": "2020-11-02"
    //   }
    // },
    // {
    //   "notification_id": 120094,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4403",
    //     "title": "Leave Request Approval",
    //     "body": "From Safi  Ahmed",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-10-01 17:30:06",
    //   "resourse_info": {
    //     "applicant": "Safi Ahmed",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-03",
    //     "leaveTo": "2020-11-03"
    //   }
    // },
    // {
    //   "notification_id": 120067,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "Gi3IEWDOPQLzsEY",
    //     "title":
    //         "Task : Shovest Flutter - Sprint 8 - Completion Request Approved",
    //     "body":
    //         "Please be informed that Ishaque Sethikunhi Ameen - Technical Manager  \n                    has approved the Completion request for the Task Shovest Flutter - Sprint 8.",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-10-01 12:42:00",
    //   "resourse_info": {
    //     "task_name": "Shovest Flutter - Sprint 8",
    //     "created_by": "Obaid Mohamed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 120045,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "1G1Ax2hx7E50xjc",
    //     "title": "Escalation – Level 1 : Task Delayed by Safi Ahmed",
    //     "body":
    //         "Please be informed that your subordinate Safi Ahmed - IOS Developer has the below task outstanding which is delayed  by 1 day . \n                        Please review the task details and take necessary action in 5 working days. \n                        If the task is not completed in 5 working days the system will identify you as the cause for the delay.",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-10-01 11:30:04",
    //   "resourse_info": {
    //     "task_name": "Shovest Club Flutter Refactor - ShopsList",
    //     "created_by": "Safi Ahmed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 119471,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "1G1Ax2hx7E50xjc",
    //     "title":
    //         "Task : Shovest Club Flutter Refactor - Shops List - Creation Approval Request",
    //     "body":
    //         "Please be informed that new Task Shovest Club Flutter Refactor - Shops List has been created by Safi Ahmed and require your approval as the line manager.Please review the request and take necessary action in 3 working days else system will consider the task as approval delayed against you and escalate to your line Manager Ishaque Sethikunhi Ameen.",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-09-23 06:56:13",
    //   "resourse_info": {
    //     "task_name": "Shovest Club Flutter Refactor - Shops List",
    //     "created_by": "Safi Ahmed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 119409,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4388",
    //     "title": "Leave Request Approval",
    //     "body": "From Saeed  Gosalaparamban",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-09-22 07:06:56",
    //   "resourse_info": {
    //     "applicant": "Saeed  Gosalaparamban",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-04",
    //     "leaveTo": "2020-11-04"
    //   }
    // },
    // {
    //   "notification_id": 119201,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "Gi3IEWDOPQLzsEY",
    //     "title": "Task : Shovest Flutter - Sprint 8 - Assigned",
    //     "body":
    //         "Please be informed that new Task Shovest Flutter - Sprint 8 has been assigned to you \n     and created by You and approved by Ishaque Sethikunhi Ameen - Technical Manager . ",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-09-18 06:20:18",
    //   "resourse_info": {
    //     "task_name": "Shovest Flutter - Sprint 8",
    //     "created_by": "Obaid Mohamed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 119008,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4383",
    //     "title": "Leave Request Approval",
    //     "body": "From Safi  Ahmed",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-09-15 09:28:01",
    //   "resourse_info": {
    //     "applicant": "Safi Ahmed",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-06",
    //     "leaveTo": "2020-11-06"
    //   }
    // },
    // {
    //   "notification_id": 118475,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "97dgYxRo8CBRCGm",
    //     "title":
    //         "Task : WallPost Flutter - Sprint 1 - Completion Request Approved",
    //     "body":
    //         "Please beinformed that Ishaque Sethikunhi Ameen - Technical Manager  \n                    has approved the Completion request for the Task WallPost Flutter - Sprint 1.",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-09-07 08:11:22",
    //   "resourse_info": {
    //     "task_name": "WallPost Flutter - Sprint 1",
    //     "created_by": "Obaid Mohamed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 118476,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "kzE8XT8vByjzZoX",
    //     "title":
    //         "Task : Shovest Club Flutter - Sprint 6 - Completion Request Approved",
    //     "body":
    //         "Please be informed that Ishaque Sethikunhi Ameen - Technical Manager  \n                    has approved the Completion request for the Task Shovest Club Flutter - Sprint 6.",
    //     "module": 1,
    //     "route": "task://TASK/task-details"
    //   },
    //   "module": "TASK",
    //   "created_at": "2020-09-07 08:11:22",
    //   "resourse_info": {
    //     "task_name": "Shovest Club Flutter - Sprint 6",
    //     "created_by": "Obaid Mohamed",
    //     "status": "Completed"
    //   }
    // },
    // {
    //   "notification_id": 117815,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4354",
    //     "title": "Leave Request Approval",
    //     "body": "From Saeed  Gosalaparamban",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-08-31 03:05:26",
    //   "resourse_info": {
    //     "applicant": "Saeed  Gosalaparamban",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-08",
    //     "leaveTo": "2020-11-08"
    //   }
    // },
    // {
    //   "notification_id": 117813,
    //   "user_id": "09TZ3NLA195FpWJ",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "4353",
    //     "title": "Leave Request Approval",
    //     "body": "From Safi Ahmed",
    //     "module": 2,
    //     "route": "hr://EP/approved-leave"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-08-30 23:36:14",
    //   "resourse_info": {
    //     "applicant": "Safi Ahmed",
    //     "leaveTypeName": "Casual",
    //     "leaveFrom": "2020-11-10",
    //     "leaveTo": "2020-11-10"
    //   }
    // }
  ];

  static var pageTwoResponse = [
    // {
    //   "notification_id": 119409,
    //   "user_id": "VyI4ZEUGQ1WLhny",
    //   "seen": "1",
    //   "company_id": 13,
    //   "data": {
    //     "reference_id": "3193",
    //     "title": "Expense Request Approval",
    //     "body": "From Saeed categories: Hosting",
    //     "module": 2,
    //     "route": "myportal://myportal/expense-details"
    //   },
    //   "module": "MYPORTAL",
    //   "created_at": "2020-10-07 06:24:39",
    //   "resourse_info": {
    //     "created_by": "Saeed",
    //     "profileImage": "DOC15470_saeed.jpg",
    //     "applicant": "Saeed",
    //     "leaveTypeName": "",
    //     "leaveFrom": "",
    //     "leaveTo": "",
    //     "notification_type": "Expense",
    //     "amount": "12194"
    //   }
    // },
    // {
    //   "company_id": 13,
    //   "created_at": "2018-06-21 05:36:18",
    //   "data": {
    //     "body":
    //         "Your approval is required on the Leave handover request of \"Annual Leave \" during 2018-07-22 - 2018-08-23",
    //     "module": 2,
    //     "reference_id": "1773",
    //     "route": "hr://EP/approve-handover",
    //     "title": "Handover Approval request of Saeed  Gosalaparamban "
    //   },
    //   "module": "MYPORTAL",
    //   "notification_id": 119409,
    //   "seen": "1",
    //   "user_id": "09TZ3NLA195FpWJ"
    // }
  ];
}
