import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/company_management/entities/company.dart';

import '../../_test_utils/map_comparer.dart';
import '../mocks.dart';

void main() {
  test('json initialization', () async {
    expect(Company.fromJson(Mocks.companiesListResponse[0]), isNotNull);
  });

  test('json conversion', () async {
    var company = Company.fromJson(Mocks.companiesListResponse[0]);

    expect(MapComparer.isMapSubsetOfAnotherMap(company.toJson(), Mocks.companiesListResponse[0]), true);
  });
}
