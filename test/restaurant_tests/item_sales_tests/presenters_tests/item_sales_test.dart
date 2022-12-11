import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/services/item_sales_provider.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/presenter/item_sales_presenter.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/view_contracts/item_sales_view.dart';

import '../../../_mocks/mock_company_provider.dart';

class MockItemSalesDataProvider extends Mock implements ItemSalesProvider {}

class MockItemSalesView extends Mock implements ItemSalesView {}

void main() {
  var ItemSalesData = MockItemSalesDataProvider();
  var view = MockItemSalesView();
  late ItemSalesPresenter presenter;

  void _initializePresenter() {
    presenter = ItemSalesPresenter.initWith(
      view,
      MockCompanyProvider(),
      ItemSalesData,
    );
  }

  _initializePresenter();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(ItemSalesData);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(ItemSalesData);
  }

  setUpAll(() {
    registerFallbackValue(SalesItemWiseOptions.viewAsCategory);
  });

  test("presenter return 0.0 for item sales data when item sales data is uninitialized yet", () {
    _initializePresenter();

    expect(presenter.getTotalQuantity(), "0");
    _clearInteractionsOnAllMocks();
  });
}
