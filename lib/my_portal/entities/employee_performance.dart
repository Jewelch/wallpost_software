import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class EmployeePerformance extends JSONInitializable {
  String _overallYearlyPerformancePercentage;
  String _bestPerformanceMonth;
  String _bestPerformancePercentage;
  String _leastPerformanceMonth;
  String _leastPerformancePercent;

  EmployeePerformance.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leastMap = sift.readMapFromMap(jsonMap, 'least');
      var bestMap = sift.readMapFromMap(jsonMap, 'best');
      _overallYearlyPerformancePercentage = sift.readStringFromMap(jsonMap, 'ytd_performance');
      _bestPerformanceMonth = sift.readStringFromMap(bestMap, 'month');
      _bestPerformancePercentage = sift.readStringFromMap(bestMap, 'score');
      _leastPerformanceMonth = sift.readStringFromMap(leastMap, 'month');
      _leastPerformancePercent = sift.readStringFromMap(leastMap, 'score');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast EmployeePerformance response. Error message - ${e.errorMessage}');
    }
  }

  String get overallYearlyPerformancePercentage => _overallYearlyPerformancePercentage;

  String get bestPerformanceMonth => _bestPerformanceMonth;

  String get bestPerformancePercentage => _bestPerformancePercentage;

  String get leastPerformanceMonth => _leastPerformanceMonth;

  String get leastPerformancePercent => _leastPerformancePercent;
}
