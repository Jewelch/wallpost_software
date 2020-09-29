import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> salesPerformanceResponse = {
    "oneYearback": {
      "actual": randomString(10),
      "actualChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "percentage": randomBetween(1000, 5000),
      "show": true,
      "target": randomString(10),
      "targetChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "year": 2019,
    },
    "selectedYear": {
      "actual": randomString(10),
      "actualChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "percentage": randomBetween(1000, 5000),
      "show": true,
      "target": randomString(10),
      "targetChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "year": '2020',
    },
    "twoYearback": {
      "actual": randomString(10),
      "actualChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "percentage": 80,
      "show": true,
      "target": randomString(10),
      "targetChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "year": 2018,
    },
  };

  static Map<String, dynamic> employeePerformanceResponse = {
    "best": {
      "month": randomString(10),
      "score": '70',
    },
    "least": {
      "month": randomString(10),
      "score": '90',
    },
    "performance": randomBetween(1000, 5000),
    "ytd_performance": '89',
  };
}
