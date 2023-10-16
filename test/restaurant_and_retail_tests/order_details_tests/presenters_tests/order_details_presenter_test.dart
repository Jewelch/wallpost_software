import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/entities/order_details.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/services/order_details_provider.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/presenter/order_details_presenter.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/view_contracts/order_details_view.dart';

import '../../../_mocks/mock_company_provider.dart';
import '../_mocks.dart';

class MockOrderDetailsReportProvider extends Mock implements OrderDetailsProvider {}

class MockOrderDetails extends Mock implements OrderDetails {}

class MockOrderDetailsView extends Mock implements OrderDetailsView {}

void main() {
  var orderDetailsReportProvider = MockOrderDetailsReportProvider();
  var view = MockOrderDetailsView();
  late OrderDetailsPresenter presenter;
  final int orderId = 123;

  void _initializePresenter() {
    presenter = OrderDetailsPresenter.initWith(view, orderDetailsReportProvider, MockCompanyProvider(), orderId);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(orderDetailsReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(orderDetailsReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockOrderDetails());
  });

  // MARK: test loading data from api

  test('loading order details when the api is loading does nothing', () async {
    //given
    when(() => orderDetailsReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadOrderDetails();

    //then
    verify(() => orderDetailsReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load order details notify ui to show error message', () async {
    //given
    when(() => orderDetailsReportProvider.isLoading).thenReturn(false);
    when(() => orderDetailsReportProvider.getDetails(any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadOrderDetails();

    verifyInOrder([
      () => orderDetailsReportProvider.isLoading,
      () => view.showLoader(),
      () => orderDetailsReportProvider.getDetails(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading hourly sales report', () async {
    //given
    var report = OrderDetails.fromJson(successfulOrdersDetailsResponse);
    when(() => orderDetailsReportProvider.isLoading).thenReturn(false);
    when(() => orderDetailsReportProvider.getDetails(any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadOrderDetails();

    verifyInOrder([
      () => orderDetailsReportProvider.isLoading,
      () => view.showLoader(),
      () => orderDetailsReportProvider.getDetails(any()),
      () => view.onDidLoadDetails(),
    ]);
    _clearInteractionsOnAllMocks();
  });
}
