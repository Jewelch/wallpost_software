import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/sales_data/presenters/sales_presenter.dart';
import 'package:wallpost/sales_data/ui/contracts/SalesDataView.dart';

import '../mocks.dart';



class MockSalesDataView extends Mock implements SalesDataView {}

void main() {
  var salesDataProvider = MockSalesDataProvider();
  var view = MockSalesDataView();
  var salesPresenter = SalesPresenter.initWith(view, salesDataProvider);

  group('tests for loading categories', () {
    test('loading sales data when the provider is loading does nothing', () async {
      //given
      when(() => salesDataProvider.isLoading).thenReturn(true);

      //when
      await salesPresenter.loadSalesData();

      //then
      verify(() => salesDataProvider.isLoading);
      verifyNoMoreInteractions(salesDataProvider);
    });

    test('failure to load sales data', () async {
      //given
      when(() => salesDataProvider.isLoading).thenReturn(false);
      when(() => salesDataProvider.getSalesAmounts()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await salesPresenter.loadSalesData();

      verifyInOrder([
        () => salesDataProvider.isLoading,
        () => view.showLoader(),
        () => salesDataProvider.getSalesAmounts(),
        () => view.hideLoader(),
        () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      ]);
      verifyNoMoreInteractions(salesDataProvider);
    });

    test('successfully loading sales data', () async {
      //given
      var salesData = MockSalesData();
      when(() => salesDataProvider.isLoading).thenReturn(false);
      when(() => salesDataProvider.getSalesAmounts()).thenAnswer((_) => Future.value(salesData));

      //when
      await salesPresenter.loadSalesData();

      //then
      verifyInOrder([
        () => salesDataProvider.isLoading,
        () => view.showLoader(),
        () => salesDataProvider.getSalesAmounts(),
        () => view.hideLoader(),
        () => view.showSalesData(salesData),
      ]);
      verifyNoMoreInteractions(salesDataProvider);
    });
  });
}
