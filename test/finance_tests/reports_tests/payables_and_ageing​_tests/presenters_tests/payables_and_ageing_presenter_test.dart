import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/reports/payables_and_ageing/entities/payables_and_ageing_data.dart';
import 'package:wallpost/finance/reports/payables_and_ageing/services/payables_and_ageing_provider.dart';
import 'package:wallpost/finance/reports/payables_and_ageing/ui/presenters/payables_and_ageing_presenter.dart';
import 'package:wallpost/finance/reports/payables_and_ageing/ui/view_contracts/payables_and_ageing_view.dart';

import '../../../../_mocks/mock_company_provider.dart';

class MockPayablesReportProvider extends Mock implements PayablesProvider {}

class MockPayablesReport extends Mock implements PayablesData {}

class MockPayablesView extends Mock implements PayablesView {}

void main() {
  var mockProvider = MockPayablesReportProvider();
  var view = MockPayablesView();
  var dateFilter = DateRange();
  late PayablesPresenter presenter;

  void _initializePresenter() {
    presenter = PayablesPresenter.initWith(
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
    registerFallbackValue(MockPayablesReport());
    registerFallbackValue(dateFilter);
  });

  test('loading payables report when the provider is loading does nothing', () async {
    //given
    when(() => mockProvider.isLoading).thenReturn(true);

    //when
    await presenter.getPayables();

    //then
    verify(() => mockProvider.isLoading);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load payables report', () async {
    //given
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.getPayables()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getPayables();

    verifyInOrder([
      () => mockProvider.isLoading,
      () => view.showLoader(),
      () => mockProvider.getPayables(),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the payables report', () async {
    //given
    var report = MockPayablesReport();
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.getPayables()).thenAnswer((_) => Future.value(report));

    //when
    await presenter.getPayables();

    verifyInOrder([
      () => mockProvider.isLoading,
      () => view.showLoader(),
      () => mockProvider.getPayables(),
      () => view.onDidLoadPayables(),
    ]);
    _clearInteractionsOnAllMocks();
  });

}