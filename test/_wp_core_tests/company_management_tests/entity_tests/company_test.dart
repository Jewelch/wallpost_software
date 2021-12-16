// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/company_management/entities/company.dart';

import '../../../_test_utils/map_comparer.dart';
import '../mocks.dart';

void main() {
  test('json initialization', () async {
    expect(Company.fromJson(Mocks.companyDetailsResponse), isNotNull);
  });

  test('json conversion', () async {
    var company = Company.fromJson(Mocks.companyDetailsResponse);

    expect(MapComparer.isMapSubsetOfAnotherMap(company.toJson(), Mocks.companyDetailsResponse), true);
  });
}
