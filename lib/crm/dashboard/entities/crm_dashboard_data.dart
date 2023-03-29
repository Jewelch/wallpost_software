import 'package:sift/sift.dart';
import 'package:wallpost/crm/dashboard/entities/service_performance.dart';
import 'package:wallpost/crm/dashboard/entities/staff_performance.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class CrmDashboardData {
  final String salesThisYear;
  final String targetAchievedPercentage;
  final String inPipeline;
  final String leadConversionPercentage;
  final String salesGrowthPercentage;
  final List<StaffPerformance> staffPerformances;
  final List<ServicePerformance> servicePerformances;

  CrmDashboardData._({
    required this.salesThisYear,
    required this.targetAchievedPercentage,
    required this.inPipeline,
    required this.leadConversionPercentage,
    required this.salesGrowthPercentage,
    required this.staffPerformances,
    required this.servicePerformances,
  });

  factory CrmDashboardData.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return CrmDashboardData._(
        salesThisYear: "0",
        targetAchievedPercentage: "0",
        inPipeline: "0",
        leadConversionPercentage: "0",
        salesGrowthPercentage: "0",
        staffPerformances: [],
        servicePerformances: [],
      );
    }

    try {
      var sift = Sift();
      List<StaffPerformance> staffPerformances = [];
      List<Map<String, dynamic>> staffPerformanceMapList = sift.readMapListFromMap(json, "staff_performance");
      staffPerformanceMapList.forEach((staffPerformanceMap) {
        var staffPerformance = StaffPerformance.fromJson(staffPerformanceMap);
        staffPerformances.add(staffPerformance);
      });

      List<ServicePerformance> servicePerformances = [];
      List<Map<String, dynamic>> servicePerformanceMapList = sift.readMapListFromMap(json, "service_performance");
      servicePerformanceMapList.forEach((servicePerformanceMap) {
        var servicePerformance = ServicePerformance.fromJson(servicePerformanceMap);
        servicePerformances.add(servicePerformance);
      });

      Map<String, dynamic> salesThisYearMap = sift.readMapFromMap(json, "sales_this_year");
      Map<String, dynamic> salesGrowthThisYearMap = sift.readMapFromMap(json, "sales_growth_this_year");
      return CrmDashboardData._(
        salesThisYear: sift.readStringFromMapWithDefaultValue(salesThisYearMap, "budgeted_revenue", "0")!,
        targetAchievedPercentage:
            sift.readStringFromMapWithDefaultValue(salesThisYearMap, "target_achieved_percentage")!,
        inPipeline: sift.readStringFromMapWithDefaultValue(salesThisYearMap, "in_pipeline", "0")!,
        leadConversionPercentage:
            sift.readStringFromMapWithDefaultValue(salesGrowthThisYearMap, "lead_conversion", "0")!,
        salesGrowthPercentage: sift.readStringFromMapWithDefaultValue(salesGrowthThisYearMap, "sales_growth", "0")!,
        staffPerformances: staffPerformances,
        servicePerformances: servicePerformances,
      );
    } catch (error) {
      throw MappingException('Failed to cast StaffPerformance response. Error message - $error');
    }
  }
}
