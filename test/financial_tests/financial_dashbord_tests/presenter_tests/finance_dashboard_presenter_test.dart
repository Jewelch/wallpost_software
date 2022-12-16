import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

import '../../../_mocks/mock_company_provider.dart';

class MockFinanceDashBoardProvider extends Mock implements FinanceDashBoardProvider {}

class MockFinanceDashBoardData extends Mock implements FinanceDashBoardData {}

class MockFinanceDashBoardView extends Mock implements FinanceDashBoardView {}

void main() {
  late MockFinanceDashBoardView view;
  late MockFinanceDashBoardProvider provider;
  late MockCompanyProvider companyProvider;
  late FinanceDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(provider);
    verifyNoMoreInteractions(companyProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(provider);
    clearInteractions(companyProvider);
  }

  setUp(() {
    view = MockFinanceDashBoardView();
    provider = MockFinanceDashBoardProvider();
    companyProvider=MockCompanyProvider();
    presenter = FinanceDashboardPresenter.initWith(
      view,
      provider,
      companyProvider,
    );
    _clearInteractionsOnAllMocks();
  });

  test('failure to load the data', () async {
    //given
    when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadFinanceDashBoardDetails();

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => provider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorAndRetryView("Failed to load finance details.\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
