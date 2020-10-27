import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> unreadNotificationsCount = {
    'total_count': randomBetween(1000, 5000),
    'companies_count': {
      'selectedCompanyId': {
        "modules": {
          "MYPORTAL": 12,
          "TASK": 73,
        },
        "total_count": 85,
      },
      'someOtherCompany': {
        "modules": {
          "MYPORTAL": randomBetween(1000, 5000),
          "TASK": randomBetween(1000, 5000),
        },
        "total_count": randomBetween(1000, 5000),
      }
    }
  };

  static List<Map<String, dynamic>> notificationsListResponse = [
    {
      "company_id": randomBetween(1000, 5000),
      "created_at": "2020-10-07 06:24:39",
      "data": {
        "body": randomString(10),
        "module": true,
        "reference_id": randomString(10),
        "route": 'someRouteWithWord:task',
        "title": randomString(10),
      },
      "module": randomString(10),
      "notification_id": randomBetween(1000, 5000),
      "resourse_info": {
        "created_by": randomString(10),
        "status": randomString(10),
        "task_name": randomString(10),
      },
      "seen": randomString(10),
      "user_id": randomString(10),
    },
    {
      "company_id": randomBetween(1000, 5000),
      "created_at": "2020-10-07 06:24:39",
      "data": {
        "body": randomString(10),
        "module": true,
        "reference_id": randomString(10),
        "route": 'someRouteWithWord:task',
        "title": randomString(10),
      },
      "module": randomString(10),
      "notification_id": randomBetween(1000, 5000),
      "resourse_info": {
        "created_by": randomString(10),
        "status": randomString(10),
        "task_name": randomString(10),
      },
      "seen": randomString(10),
      "user_id": randomString(10),
    },
  ];
}
