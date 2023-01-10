import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/entities/crm_dashboard_data.dart';

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
}
