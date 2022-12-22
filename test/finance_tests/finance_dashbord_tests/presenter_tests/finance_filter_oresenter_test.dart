
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/finance/entities/finance_bill_details.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/entities/finance_invoice_details.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/presenters/finance_filter_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

class MockFinanceDashBoardProvider extends Mock implements FinanceDashBoardProvider {}

class MockFinanceDashBoardData extends Mock implements FinanceDashBoardData {}

class MockFinanceInvoiceDetails extends Mock implements FinanceInvoiceDetails{}

class MockFinanceBillDetails extends Mock implements FinanceBillDetails{}


void main() {
  late MockFinanceDashBoardProvider provider;
  late FinanceFiltersPresenter presenter;

  // void _verifyNoMoreInteractionsOnAllMocks() {
  //   verifyNoMoreInteractions();
  //   verifyNoMoreInteractions(provider);
  // }
  //
  // void _clearInteractionsOnAllMocks() {
  //   clearInteractions(view);
  //   clearInteractions(provider);
  //   clearInteractions(companyProvider);
  // }

  setUp(() {
    // view = MockFinanceDashBoardView();
    // provider = MockFinanceDashBoardProvider();
    // companyProvider = MockCompanyProvider();
    // presenter = FinanceFiltersPresenter.initWith(
    //
    // );
    //_clearInteractionsOnAllMocks();
  });

  // test('failure to load the finance dashboard details', () async {
  //   //given
  //   when(() => provider.isLoading).thenReturn(false);
  //   when(() => provider.get(month: any(named: "month"), year: any(named: "year")))
  //       .thenAnswer((_) => Future.error(InvalidResponseException()));
  //
  //   //when
  //   await presenter.loadFinanceDashBoardDetails();
  //
  //   //then
  //   verifyInOrder([
  //         () => provider.isLoading,
  //         () => view.showLoader(),
  //         () => provider.get(month: any(named: "month"), year: any(named: "year")),
  //         () => view.showErrorAndRetryView("Failed to load finance details.\nTap here to reload."),
  //   ]);
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
}