import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/entities/crm_dashboard_data.dart';

import '../mocks.dart';

void main() {
  test("actual revenue", () {
    var json = Mocks.crmDashboardDataResponse;

    json["actual_revenue"] = "-20";
    var data = CRMDashboardData.fromJson(json);
    expect(data.isActualRevenuePositive(), false);

    json["actual_revenue"] = "100";
    data = CRMDashboardData.fromJson(json);
    expect(data.isActualRevenuePositive(), true);
  });

  test("target achieved", () {
    var json = Mocks.crmDashboardDataResponse;

    json["target_achieved_percentage"] = 10;
    var data = CRMDashboardData.fromJson(json);
    expect(data.isTargetAchievedPercentLow(), true);
    expect(data.isTargetAchievedPercentMedium(), false);
    expect(data.isTargetAchievedPercentHigh(), false);

    json["target_achieved_percentage"] = 70;
    data = CRMDashboardData.fromJson(json);
    expect(data.isTargetAchievedPercentMedium(), true);
    expect(data.isTargetAchievedPercentLow(), false);
    expect(data.isTargetAchievedPercentHigh(), false);

    json["target_achieved_percentage"] = 90;
    data = CRMDashboardData.fromJson(json);
    expect(data.isTargetAchievedPercentHigh(), true);
    expect(data.isTargetAchievedPercentLow(), false);
    expect(data.isTargetAchievedPercentMedium(), false);
  });

  test("lead converted", () {
    var json = Mocks.crmDashboardDataResponse;

    json["lead_converted_percentage"] = 10;
    var data = CRMDashboardData.fromJson(json);
    expect(data.isLeadConvertedPercentLow(), true);
    expect(data.isLeadConvertedPercentMedium(), false);
    expect(data.isLeadConvertedPercentHigh(), false);

    json["lead_converted_percentage"] = 70;
    data = CRMDashboardData.fromJson(json);
    expect(data.isLeadConvertedPercentMedium(), true);
    expect(data.isLeadConvertedPercentLow(), false);
    expect(data.isLeadConvertedPercentHigh(), false);

    json["lead_converted_percentage"] = 90;
    data = CRMDashboardData.fromJson(json);
    expect(data.isLeadConvertedPercentHigh(), true);
    expect(data.isLeadConvertedPercentLow(), false);
    expect(data.isLeadConvertedPercentMedium(), false);
  });
}
