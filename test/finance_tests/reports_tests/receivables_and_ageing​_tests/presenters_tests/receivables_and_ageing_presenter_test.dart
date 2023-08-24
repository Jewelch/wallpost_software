import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/entities/receivables_and_ageing_data.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/services/receivables_and_ageing_provider.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/ui/presenters/receivables_and_ageing_presenter.dart';
import 'package:wallpost/finance/reports/receivables_and_ageing/ui/view_contracts/receivables_and_ageing_view.dart';

import '../../../../_mocks/mock_company_provider.dart';

class MockReceivablesReportProvider extends Mock implements ReceivablesProvider {}

class MockReceivablesReport extends Mock implements ReceivablesData {}

class MockReceivablesView extends Mock implements ReceivablesView {}

void main() {
  var mockProvider = MockReceivablesReportProvider();
  var view = MockReceivablesView();
  var dateFilter = DateRange();
  late ReceivablesPresenter presenter;

  void _initializePresenter() {
    presenter = ReceivablesPresenter.initWith(
      view,
      mockProvider,
      MockCompanyProvider(),
    );
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(mockProvider);
  }

  setUp(() {
    _clearInteractionsOnAllMocks();
    _initializePresenter();
  });

  setUpAll(() {
    registerFallbackValue(MockReceivablesReport());
    registerFallbackValue(dateFilter);
  });

  test('loading receivables report when the provider is loading does nothing', () async {
    //given
    when(() => mockProvider.isLoading).thenReturn(true);

    //when
    await presenter.getReceivables();

    //then
    verify(() => mockProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load receivables report', () async {
    //given
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.getReceivables()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getReceivables();

    verifyInOrder([
      () => mockProvider.isLoading,
      () => view.showLoader(),
      () => mockProvider.getReceivables(),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the receivables report', () async {
    //given
    var report = MockReceivablesReport();
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.getReceivables()).thenAnswer((_) => Future.value(report));

    //when
    await presenter.getReceivables();

    verifyInOrder([
      () => mockProvider.isLoading,
      () => view.showLoader(),
      () => mockProvider.getReceivables(),
      () => view.onDidLoadReceivables(),
    ]);
    _clearInteractionsOnAllMocks();
  });

}