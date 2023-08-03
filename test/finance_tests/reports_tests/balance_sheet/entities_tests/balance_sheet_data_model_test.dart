import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/finance/reports/balance_sheet/entities/balance_sheet_data.dart';

import '../mocks.dart';

void main() {
  test('BalanceSheetDataModel serialization succeeds when data is valid', () {
    BalanceSheetData.fromJson(Mocks.balanceSheetReportResponse);
  });

  test('BalanceSheetDataModel serialization throws a <MappingException> when data is invalid', () {
    try {
      BalanceSheetData.fromJson({});

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
