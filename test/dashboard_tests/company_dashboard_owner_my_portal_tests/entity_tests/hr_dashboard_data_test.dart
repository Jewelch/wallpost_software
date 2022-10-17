import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/entities/hr_dashboard_data.dart';

import '../mocks.dart';

void main() {
  test("is staff on leave", () {
    var json = Mocks.hrDashboardDataResponse;

    json["staff_on_leave"] = "0";
    var data = HRDashboardData.fromJson(json);
    expect(data.isAnyStaffOnLeave(), false);

    json["staff_on_leave"] = "3";
    data = HRDashboardData.fromJson(json);
    expect(data.isAnyStaffOnLeave(), true);
  });

  test("are documents expired", () {
    var json = Mocks.hrDashboardDataResponse;

    json["documents_expired"] = "0";
    var data = HRDashboardData.fromJson(json);
    expect(data.areAnyDocumentsExpired(), false);

    json["documents_expired"] = "3";
    data = HRDashboardData.fromJson(json);
    expect(data.areAnyDocumentsExpired(), true);
  });
}
