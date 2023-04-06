import 'package:sift/sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class ServicePerformance {
  final String name;
  final String target;
  final String actual;
  final String performancePercentage;

  ServicePerformance._({
    required this.name,
    required this.target,
    required this.actual,
    required this.performancePercentage,
  });

  factory ServicePerformance.fromJson(Map<String, dynamic> json) {
    try {
      var sift = Sift();
      return ServicePerformance._(
        name: sift.readStringFromMap(json, "name"),
        target: sift.readStringFromMapWithDefaultValue(json, "target", "0")!,
        actual: sift.readStringFromMapWithDefaultValue(json, "actual", "0")!,
        performancePercentage: sift.readStringFromMapWithDefaultValue(json, "achievment_percentage", "0")!,
      );
    } catch (error) {
      throw MappingException('Failed to cast ServicePerformance response. Error message - $error');
    }
  }
}
