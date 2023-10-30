import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/reports/stock_expiration/entities/stock_expiration.dart';
import 'package:wallpost/finance/reports/stock_expiration/services/stock_expiration_provider.dart';
import 'package:wallpost/finance/reports/stock_expiration/ui/presenter/stock_expiration_presenter.dart';
import 'package:wallpost/finance/reports/stock_expiration/ui/view_contracts/stock_expiration_view.dart';

import '../../../../_mocks/mock_company_provider.dart';

class MockStocksExpirationReportProvider extends Mock implements StocksExpirationProvider {}

class MockStock extends Mock implements StockExpiration {}

class MockStocksExpirationView extends Mock implements StocksExpirationView {}

void main() {
  var stocksExpirationReportProvider = MockStocksExpirationReportProvider();
  var view = MockStocksExpirationView();
  var dateFilter = DateRange();
  late StocksExpirationPresenter presenter;

  void _initializePresenter() {
    presenter = StocksExpirationPresenter.initWith(view, stocksExpirationReportProvider, MockCompanyProvider());
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(stocksExpirationReportProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(stocksExpirationReportProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(dateFilter);
  });

  // MARK: test load stocks expiration functions

  test('loading stocks expiration report when the report provider is loading does nothing', () async {
    //given
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadNext();

    //then
    verify(() => stocksExpirationReportProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load stocks expiration report notify ui error has been occurred', () async {
    //given
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any()))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadNext();

    verifyInOrder([
      () => stocksExpirationReportProvider.isLoading,
      () => view.showLoader(),
      () => stocksExpirationReportProvider.getNext(any(), any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the stocks expiration report first time but with empty list show no stocks message',
      () async {
    //given
    var report = <StockExpiration>[];
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadNext();

    verifyInOrder([
      () => stocksExpirationReportProvider.isLoading,
      () => view.showLoader(),
      () => stocksExpirationReportProvider.getNext(any(), any()),
      () => view.onDidLoadReport(),
      () => view.showNoStocksMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
  test('successfully loading the stocks expiration report first time (no pagination yet)', () async {
    //given
    var report = [MockStock(), MockStock()];
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any())).thenAnswer((_) => Future.value(report));

    //when
    await presenter.loadNext();

    verifyInOrder([
      () => stocksExpirationReportProvider.isLoading,
      () => view.showLoader(),
      () => stocksExpirationReportProvider.getNext(any(), any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the stocks expiration report with pagination', () async {
    //given
    var report = [MockStock(), MockStock()];
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any())).thenAnswer((_) => Future.value(report));
    await presenter.loadNext();
    _clearInteractionsOnAllMocks();

    //when
    await presenter.loadNext();

    verifyInOrder([
      () => stocksExpirationReportProvider.isLoading,
      () => view.showPaginationLoader(),
      () => stocksExpirationReportProvider.getNext(any(), any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('searching stocks return only the matched ones', () async {
    //given
    var mockStock = MockStock();
    var mockStock2 = MockStock();
    when(() => mockStock.name).thenReturn("Pepsi");
    when(() => mockStock2.name).thenReturn("Coke");
    var report = [mockStock, mockStock2];
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any())).thenAnswer((_) => Future.value(report));
    await presenter.loadNext();
    _clearInteractionsOnAllMocks();

    //when
    presenter.onSearch("pe");

    expect(presenter.searchText, 'pe');
    expect(presenter.stocksExpiration.length, 1);
    expect(presenter.stocksExpiration[0].name, "Pepsi");
    verify(() => view.onDidLoadReport());
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('clicking on get only expired ones reset the pagination and clear the current list', () async {
    //given
    var report = [MockStock(), MockStock()];
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any())).thenAnswer((_) => Future.value(report));
    await presenter.loadNext();
    _clearInteractionsOnAllMocks();

    //when
    presenter.onSelectOnlyExpired();

    expect(presenter.isExpired, true);
    expect(presenter.stocksExpiration.length, 0);
    // to make the async call (event loop run)
    await Future.delayed(Duration.zero);

    verifyInOrder([
      () => stocksExpirationReportProvider.reset(),
      () => stocksExpirationReportProvider.isLoading,
      () => view.showLoader(),
      () => stocksExpirationReportProvider.getNext(true, any()),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('clicking on get expired in days reset the pagination and clear the current list', () async {
    //given
    var report = [MockStock(), MockStock()];
    when(() => stocksExpirationReportProvider.isLoading).thenReturn(false);
    when(() => stocksExpirationReportProvider.getNext(any(), any())).thenAnswer((_) => Future.value(report));
    await presenter.loadNext();
    _clearInteractionsOnAllMocks();

    //when
    presenter.onSelectExpiredInDays(30);

    expect(presenter.isExpired, false);
    expect(presenter.stocksExpiration.length, 0);
    // to make the async call (event loop run)
    await Future.delayed(Duration.zero);

    verifyInOrder([
      () => stocksExpirationReportProvider.reset(),
      () => stocksExpirationReportProvider.isLoading,
      () => view.showLoader(),
      () => stocksExpirationReportProvider.getNext(false, 30),
      () => view.onDidLoadReport(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
