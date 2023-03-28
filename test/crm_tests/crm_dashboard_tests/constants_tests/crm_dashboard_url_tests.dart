import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/crm/dashboard/constants/crm_dashboard_urls.dart';

void main() {
  test('month is set to YTD if it is 0', () {
    String url = CrmDashboardUrls.getDashboardDataUrl("companyId", 0, 2022);

    expect(url.contains('YTD'), true);
  });

  test('month is set to the passed month if it is not 0', () {
    String url = CrmDashboardUrls.getDashboardDataUrl("companyId", 5, 2022);

    expect(url.contains('5'), true);
  });
}
