import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class EmployeePerformance extends JSONInitializable {
  int _overallYearlyPerformancePercent;
  String _bestPerformanceMonth;
  int _bestPerformancePercent;
  String _leastPerformanceMonth;
  int _leastPerformancePercent;

  EmployeePerformance.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leastMap = sift.readMapFromMap(jsonMap, 'least');
      var bestMap = sift.readMapFromMap(jsonMap, 'best');
      _overallYearlyPerformancePercent =
          int.parse(sift.readStringFromMapWithDefaultValue(jsonMap, 'ytd_performance', '0'));
      _bestPerformanceMonth = sift.readStringFromMap(bestMap, 'month');
      _bestPerformancePercent = int.parse(sift.readStringFromMap(bestMap, 'score'));
      _leastPerformanceMonth = sift.readStringFromMap(leastMap, 'month');
      _leastPerformancePercent = int.parse(sift.readStringFromMap(leastMap, 'score'));
    } on SiftException catch (e) {
      throw MappingException('Failed to cast EmployeePerformance response. Error message - ${e.errorMessage}');
    }
  }

  int get overallYearlyPerformancePercent => _overallYearlyPerformancePercent;

  String get bestPerformanceMonth => _bestPerformanceMonth;

  int get bestPerformancePercent => _bestPerformancePercent;

  String get leastPerformanceMonth => _leastPerformanceMonth;

  int get leastPerformancePercent => _leastPerformancePercent;
}
