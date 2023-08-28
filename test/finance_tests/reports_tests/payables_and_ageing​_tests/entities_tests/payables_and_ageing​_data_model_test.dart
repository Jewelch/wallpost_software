import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/finance/reports/payables_and_ageing/entities/payables_and_ageing_data.dart';

import '../mocks.dart';

void main() {
  test('Payables serialization succeeds when data is valid', () {
    PayablesData.fromJson(Mocks.payablesResponse);
  });

  test('Payables serialization throws a <MappingException> when data is invalid', () {
    try {
      PayablesData.fromJson({});

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
