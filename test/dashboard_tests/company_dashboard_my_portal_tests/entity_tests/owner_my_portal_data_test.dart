import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/company_dashboard_my_portal/entities/owner_my_portal_data.dart';

import '../mocks.dart';

void main() {
  test('cutoff percentages', () {
    var data = OwnerMyPortalData.fromJson(Mocks.ownerMyPortalDataResponse, "USD");

    expect(data.lowPerformanceCutoff(), 65);
    expect(data.mediumPerformanceCutoff(), 79);
  });
  test('low company performance', () {
    var lowPerformanceMap = Mocks.ownerMyPortalDataResponse;
    lowPerformanceMap['company_performance'] = 40;

    var data = OwnerMyPortalData.fromJson(lowPerformanceMap, "USD");

    expect(data.isCompanyPerformanceLow(), true);
    expect(data.isCompanyPerformanceMedium(), false);
    expect(data.isCompanyPerformanceHigh(), false);
  });

  test('medium company performance', () {
    var lowPerformanceMap = Mocks.ownerMyPortalDataResponse;
    lowPerformanceMap['company_performance'] = 75;

    var data = OwnerMyPortalData.fromJson(lowPerformanceMap, "USD");

    expect(data.isCompanyPerformanceLow(), false);
    expect(data.isCompanyPerformanceMedium(), true);
    expect(data.isCompanyPerformanceHigh(), false);
  });

  test('high company performance', () {
    var lowPerformanceMap = Mocks.ownerMyPortalDataResponse;
    lowPerformanceMap['company_performance'] = 90;

    var data = OwnerMyPortalData.fromJson(lowPerformanceMap, "USD");

    expect(data.isCompanyPerformanceLow(), false);
    expect(data.isCompanyPerformanceMedium(), false);
    expect(data.isCompanyPerformanceHigh(), true);
  });
}
