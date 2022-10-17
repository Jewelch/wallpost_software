import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class CRMDashboardData extends JSONInitializable {
  late final String _actualRevenue;
  late final int _targetAchievedPercent;
  late final String _inPipeline;
  late final int _leadConvertedPercent;

  CRMDashboardData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _actualRevenue = sift.readStringFromMap(jsonMap, "actual_revenue");
      _targetAchievedPercent = sift.readNumberFromMap(jsonMap, "target_achieved_percentage").toInt();
      _inPipeline = sift.readStringFromMap(jsonMap, "in_pipeline");
      _leadConvertedPercent = sift.readNumberFromMap(jsonMap, "lead_converted_percentage").toInt();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast CRMDashboardData response. Error message - ${e.errorMessage}');
    }
  }

  bool isActualRevenuePositive() {
    return _isLessThanZero(_actualRevenue) == false;
  }

  bool _isLessThanZero(String value) {
    return value.contains("-");
  }

  bool isTargetAchievedPercentLow() {
    return _targetAchievedPercent <= lowPerformanceCutoff();
  }

  bool isTargetAchievedPercentMedium() {
    return _targetAchievedPercent > lowPerformanceCutoff() && _targetAchievedPercent <= mediumPerformanceCutoff();
  }

  bool isTargetAchievedPercentHigh() {
    return _targetAchievedPercent > mediumPerformanceCutoff();
  }

  bool isLeadConvertedPercentLow() {
    return _leadConvertedPercent <= lowPerformanceCutoff();
  }

  bool isLeadConvertedPercentMedium() {
    return _leadConvertedPercent > lowPerformanceCutoff() && _leadConvertedPercent <= mediumPerformanceCutoff();
  }

  bool isLeadConvertedPercentHigh() {
    return _leadConvertedPercent > mediumPerformanceCutoff();
  }

  int lowPerformanceCutoff() {
    return 65;
  }

  int mediumPerformanceCutoff() {
    return 79;
  }

  String get actualRevenue => _actualRevenue;

  int get targetAchievedPercent => _targetAchievedPercent;

  String get inPipeline => _inPipeline;

  int get leadConvertedPercent => _leadConvertedPercent;
}
