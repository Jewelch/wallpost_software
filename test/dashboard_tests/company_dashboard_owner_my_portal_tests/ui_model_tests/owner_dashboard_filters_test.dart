import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/models/owner_dashboard_filters.dart';

void main() {
  test("get month year string when no month is selected", () {
    var filters = OwnerDashboardFilters();

    expect(filters.getMonthYearString(), "YTD");
  });

  test("get month year string when a month is selected", () {
    var filters = OwnerDashboardFilters();

    filters.year = AppYears().years().first;
    filters.month = 3;

    expect(filters.getMonthYearString(), "Mar ${AppYears().years().first}");
  });
}
