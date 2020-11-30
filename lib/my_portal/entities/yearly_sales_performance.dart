import 'package:sift/sift.dart';
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

  YearlySalesPerformance.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _year = _readYearFromResponse(jsonMap);
      _performancePercentage = sift.readNumberFromMap(jsonMap, 'percentage');
      _actualSales = sift.readStringFromMap(jsonMap, 'actual');
      _targetedSales = sift.readStringFromMap(jsonMap, 'target');
      _actualMonthlySales = sift
          .readNumberListFromMapWithDefaultValue(jsonMap, 'actualChart', []);
      _targetedMonthlySales = sift
          .readNumberListFromMapWithDefaultValue(jsonMap, 'targetChart', []);
      _show = sift.readBooleanFromMap(jsonMap, 'show');
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast YearlySalesPerformance response. Error message - ${e.errorMessage}');
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

  List<num> get monthlySalesPercentages {
    List<num> percentages = [];

    for (int i = 0; i < _actualMonthlySales.length; i++) {
      num actualMonthlySale = _actualMonthlySales[i];
      num targetedMonthlySale = 0;
      if (_targetedMonthlySales.length > i)
        targetedMonthlySale = _targetedMonthlySales[i];

      var percentage = actualMonthlySale;
      if (targetedMonthlySale != 0)
        percentage = actualMonthlySale / targetedMonthlySale * 100;

      if (percentage > 100) percentage = 100;

      percentages.add(percentage.toInt());
    }

    return percentages;
  }

  bool get show => _show;
}
