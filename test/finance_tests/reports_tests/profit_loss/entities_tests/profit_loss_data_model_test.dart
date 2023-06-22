import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/finance/reports/profit_loss/entities/profit_loss_model.dart';

import '../mocks.dart';

void main() {
  test('ProfitLossDataModel serialization succeeds when data is valid', () {
    ProfitsLossesReport.fromJson(Mocks.profitLossReportResponse);
  });

  test('ProfitLossDataModel serialization throws a <MappingException> when data is invalid', () {
    try {
      ProfitsLossesReport.fromJson({});

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
