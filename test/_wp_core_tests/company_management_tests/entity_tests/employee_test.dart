// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/company_management/entities/employee.dart';

import '../../../_test_utils/map_comparer.dart';
import '../mocks.dart';

void main() {
  test('json initialization', () async {
    expect(Employee.fromJson(Mocks.companyDetailsResponse), isNotNull);
  });

  test('json conversion', () async {
    var employee = Employee.fromJson(Mocks.companyDetailsResponse);

    expect(MapComparer.isMapSubsetOfAnotherMap(employee.toJson(), Mocks.companyDetailsResponse), true);
  });
}
