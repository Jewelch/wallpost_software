import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/entities/hr_dashboard_data.dart';

import '../mocks.dart';

void main() {
  test("has any active staff", () {
    var json = Mocks.hrDashboardDataResponse;

    json["active_staff"] = "0";
    var data = HRDashboardData.fromJson(json);
    expect(data.hasAnyActiveStaff(), false);

    json["active_staff"] = "3";
    data = HRDashboardData.fromJson(json);
    expect(data.hasAnyActiveStaff(), true);
  });

  test("is staff on leave", () {
    var json = Mocks.hrDashboardDataResponse;

    json["staff_on_leave"] = "0";
    var data = HRDashboardData.fromJson(json);
    expect(data.isAnyStaffOnLeave(), false);

    json["staff_on_leave"] = "3";
    data = HRDashboardData.fromJson(json);
    expect(data.isAnyStaffOnLeave(), true);
  });

  test("recruitment", () {
    var json = Mocks.hrDashboardDataResponse;

    json["recruitment"] = "0";
    var data = HRDashboardData.fromJson(json);
    expect(data.isRecruitmentPending(), false);

    json["recruitment"] = "3";
    data = HRDashboardData.fromJson(json);
    expect(data.isRecruitmentPending(), true);
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
