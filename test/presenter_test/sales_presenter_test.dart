import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '_mocks.dart';

class SalesPresenter {
  SalesDataProvider _salesDataProvider;
  SalesDataView _view;

  SalesPresenter(this._view) : _salesDataProvider = SalesDataProvider();

  SalesPresenter.initWith(this._view, this._salesDataProvider);

  Future loadSalesData() async {
    if (_salesDataProvider.isLoading) return;
    _view.showLoader();
    try {
      var salesData = await _salesDataProvider.getSalesData();
      _view.hideLoader();
      _view.showSalesData(salesData);
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }
}

abstract class SalesDataView {
  void showLoader();

  void hideLoader();

  void showErrorMessage(String errorMessage) {}

  void showSalesData(SalesData salesData) {}
}

class SalesData {}

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
      when(() => salesDataProvider.getSalesData()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await salesPresenter.loadSalesData();

      verifyInOrder([
        () => salesDataProvider.isLoading,
        () => view.showLoader(),
        () => salesDataProvider.getSalesData(),
        () => view.hideLoader(),
        () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      ]);
      verifyNoMoreInteractions(salesDataProvider);
    });

    test('successfully loading sales data', () async {
      //given
      var salesData = SalesData();
      when(() => salesDataProvider.isLoading).thenReturn(false);
      when(() => salesDataProvider.getSalesData()).thenAnswer((_) => Future.value(salesData));
      //when
      await salesPresenter.loadSalesData();

      //then
      verifyInOrder([
        () => salesDataProvider.isLoading,
        () => view.showLoader(),
        () => salesDataProvider.getSalesData(),
        () => view.hideLoader(),
        () => view.showSalesData(salesData),
      ]);
      verifyNoMoreInteractions(salesDataProvider);
    });
  });
}
