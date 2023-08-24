import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/entities/receivables_and_ageing_data.dart';

import '../mocks.dart';

void main() {
  test('Receivables serialization succeeds when data is valid', () {
    ReceivablesData.fromJson(Mocks.receivablesResponse);
  });

  test('Receivables serialization throws a <MappingException> when data is invalid', () {
    try {
      ReceivablesData.fromJson({});

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
