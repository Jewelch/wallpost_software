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
}
