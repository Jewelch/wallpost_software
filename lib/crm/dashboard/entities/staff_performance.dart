import 'package:sift/Sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class StaffPerformance {
  final String name;
  final String profileImageUrl;
  final String target;
  final String actual;
  final String performancePercentage;

  StaffPerformance._({
    required this.name,
    required this.profileImageUrl,
    required this.target,
    required this.actual,
    required this.performancePercentage,
  });

  factory StaffPerformance.fromJson(Map<String, dynamic> json) {
    try {
      var sift = Sift();
      return StaffPerformance._(
        name: sift.readStringFromMap(json, "salesman_name"),
        profileImageUrl: sift.readStringFromMap(json, "photo_url"),
        target: sift.readStringFromMapWithDefaultValue(json, "target_amount", "0")!,
        actual: sift.readStringFromMapWithDefaultValue(json, "actual_amount", "0")!,
        performancePercentage: sift.readStringFromMapWithDefaultValue(json, "percentage", "0")!,
      );
    } catch (error) {
      throw MappingException('Failed to cast StaffPerformance response. Error message - $error');
    }
  }
}
