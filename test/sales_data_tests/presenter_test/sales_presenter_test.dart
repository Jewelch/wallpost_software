import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/sales_data_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/sales_presenter.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/view_contracts/sales_data_view.dart';

import '../mocks.dart';

class MockSalesDataProvider extends Mock implements SalesDataProvider {}

class MockSalesDataView extends Mock implements SalesDataView {}

void main() {
  var salesDataProvider = MockSalesDataProvider();
  var view = MockSalesDataView();
  var salesPresenter = SalesPresenter.initWith(view, salesDataProvider);

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(salesDataProvider);
  }

  group('tests for loading categories', () {
    test('loading sales data when the provider is loading does nothing', () async {
      //given
      when(() => salesDataProvider.isLoading).thenReturn(true);

      //when
      await salesPresenter.loadSalesData();

      //then
      verify(() => salesDataProvider.isLoading);
      _verifyNoMoreInteractionsOnAllMocks();
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
        () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
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
        () => view.showSalesData(salesData),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });
}
