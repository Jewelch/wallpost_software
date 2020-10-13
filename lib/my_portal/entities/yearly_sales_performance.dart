import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class YearlySalesPerformance extends JSONInitializable {
  num _year;
  num _performancePercentage;
  String _actualSales;
  String _targetedSales;
  List<num> _actualMonthlySales;
  List<num> _targetedMonthlySales;
  bool _show;

  YearlySalesPerformance.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _year = _readYearFromResponse(jsonMap);
      _performancePercentage = sift.readNumberFromMap(jsonMap, 'percentage');
      _actualSales = sift.readStringFromMap(jsonMap, 'actual');
      _targetedSales = sift.readStringFromMap(jsonMap, 'target');
      _actualMonthlySales = sift.readNumberListFromMapWithDefaultValue(jsonMap, 'actualChart', []);
      _targetedMonthlySales = sift.readNumberListFromMapWithDefaultValue(jsonMap, 'targetChart', []);
      _show = sift.readBooleanFromMap(jsonMap, 'show');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast YearlySalesPerformance response. Error message - ${e.errorMessage}');
    }
  }

  num _readYearFromResponse(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      return sift.readNumberFromMap(jsonMap, 'year');
    } on SiftException catch (_) {
      var yearString = sift.readStringFromMap(jsonMap, 'year');
      return int.parse(yearString);
    }
  }

  num get year => _year;

  num get performancePercentage => _performancePercentage;

  String get actualSales => _actualSales;

  String get targetedSales => _targetedSales;

  List<num> get actualMonthlySales => _actualMonthlySales;

  List<num> get targetedMonthlySales => _targetedMonthlySales;

  bool get show => _show;
}
