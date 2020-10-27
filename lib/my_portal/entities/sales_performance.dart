import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/my_portal/entities/yearly_sales_performance.dart';

class SalesPerformance extends JSONInitializable {
  YearlySalesPerformance _currentYearPerformance;
  YearlySalesPerformance _lastYearPerformance;
  YearlySalesPerformance _twoYearsBackPerformance;

  SalesPerformance.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var selectedYearMap = sift.readMapFromMap(jsonMap, 'selectedYear');
      var oneYearBackMap = sift.readMapFromMap(jsonMap, 'oneYearback');
      var twoYearBackMap = sift.readMapFromMap(jsonMap, 'twoYearback');
      _currentYearPerformance = YearlySalesPerformance.fromJson(selectedYearMap);
      _lastYearPerformance = YearlySalesPerformance.fromJson(oneYearBackMap);
      _twoYearsBackPerformance = YearlySalesPerformance.fromJson(twoYearBackMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast SalesPerformance response. Error message - ${e.errorMessage}');
    }
  }

  YearlySalesPerformance get currentYearPerformance => _currentYearPerformance;

  YearlySalesPerformance get lastYearPerformance => _lastYearPerformance;

  YearlySalesPerformance get twoYearsBackPerformance => _twoYearsBackPerformance;
}
