import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';

import '../../_test_utils/map_comparer.dart';
import '../mocks.dart';

void main() {
  test('json initialization', () async {
    expect(CompanyListItem.fromJson(Mocks.companiesListResponse[0]), isNotNull);
  });

  test('json conversion', () async {
    var company = CompanyListItem.fromJson(Mocks.companiesListResponse[0]);

    expect(MapComparer.isMapSubsetOfAnotherMap(company.toJson(), Mocks.companiesListResponse[0]), true);
  });
}
