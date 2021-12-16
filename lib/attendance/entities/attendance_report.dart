// @dart=2.9

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

class AttendanceReport {
  num _presents;
  num _absents;
  num _late;
  num _earlyLeave;
  num _leaves;

  AttendanceReport.fromJson(List<Map<String, dynamic>> jsonMapList) {
    var sift = Sift();
    try {
      var reportMap = sift.readMapFromList(jsonMapList, 0);
      _presents = sift.readNumberFromMap(reportMap, 'Presents');
      _absents = sift.readNumberFromMap(reportMap, 'Absents');
      _late = sift.readNumberFromMap(reportMap, 'Late');
      _earlyLeave = sift.readNumberFromMap(reportMap, 'EarlyLeave');
      _leaves = sift.readNumberFromMap(reportMap, 'Leaves');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AttendanceReport response. Error message - ${e.errorMessage}');
    }
  }

  num get presents => _presents;

  num get absents => _absents;

  num get late => _late;

  num get earlyLeave => _earlyLeave;

  num get leaves => _leaves;
}
