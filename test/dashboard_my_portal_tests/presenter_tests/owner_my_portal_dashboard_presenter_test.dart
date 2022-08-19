import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/dashboard_my_portal/entities/owner_my_portal_data.dart';
import 'package:wallpost/dashboard_my_portal/services/owner_my_portal_data_provider.dart';
import 'package:wallpost/dashboard_my_portal/ui/presenters/owner_my_portal_dashboard_presenter.dart';
import 'package:wallpost/dashboard_my_portal/ui/view_contracts/owner_my_portal_view.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../../expense_list_tests/services_tests/expense_list_provider_test.dart';
import '../mocks.dart';

class MockOwnerMyPortalView extends Mock implements OwnerMyPortalView {}

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockAggregatedApproval extends Mock implements AggregatedApproval {}

class MockOwnerMyPortalData extends Mock implements OwnerMyPortalData {}

class MockOwnerMyPortalDataProvider extends Mock implements OwnerMyPortalDataProvider {}

void main() {
  late MockOwnerMyPortalView view;
  late MockOwnerMyPortalDataProvider dataProvider;
  late MockSelectedCompanyProvider companyProvider;
  late OwnerMyPortalDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
    verifyNoMoreInteractions(companyProvider);
  }

  setUp(() {
    view = MockOwnerMyPortalView();
    dataProvider = MockOwnerMyPortalDataProvider();
    companyProvider = MockSelectedCompanyProvider();
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
    presenter = OwnerMyPortalDashboardPresenter.initWith(view, dataProvider, companyProvider);
  });

  test('loading data when service is loading does nothing', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(true);
    when(() => dataProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(),
      () => view.showErrorMessage(InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(MockOwnerMyPortalData()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('getting financial summary', () async {
    //given
    var financialSummary = MockFinancialSummary();
    var data = MockOwnerMyPortalData();
    when(() => data.financialSummary).thenReturn(financialSummary);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getFinancialSummary(), financialSummary);
  });

  test('getting absentees data when there are no absentees', () async {
    //given
    var data = MockOwnerMyPortalData();
    when(() => data.absentees).thenReturn(0);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getAbsenteesData().numberOfAbsentees, 0);
    expect(presenter.getAbsenteesData().countTextColor, AppColors.successColor);
  });

  test('getting absentees data when there are absentees', () async {
    //given
    var data = MockOwnerMyPortalData();
    when(() => data.absentees).thenReturn(10);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getAbsenteesData().numberOfAbsentees, 10);
    expect(presenter.getAbsenteesData().countTextColor, AppColors.failureColor);
  });

  test('getting total approval count', () async {
    //given
    var approval1 = MockAggregatedApproval();
    var approval2 = MockAggregatedApproval();
    var approval3 = MockAggregatedApproval();
    when(() => approval1.approvalCount).thenReturn(3);
    when(() => approval2.approvalCount).thenReturn(4);
    when(() => approval3.approvalCount).thenReturn(23);
    var data = MockOwnerMyPortalData();
    when(() => data.aggregatedApprovals).thenReturn([approval1, approval2, approval3]);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getTotalApprovalCount(), 30);
  });

  test('getting cutoff graph sections', () async {
    //given
    var data = OwnerMyPortalData.fromJson(Mocks.ownerMyPortalDataResponse);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var cutoffSections = presenter.getCutoffPerformanceGraphSections();

    //then
    expect(cutoffSections[0].value, data.lowPerformanceCutoff());
    expect(cutoffSections[0].color, AppColors.graphLowValueColor.withOpacity(0.3));

    expect(cutoffSections[1].value, data.mediumPerformanceCutoff() - data.lowPerformanceCutoff());
    expect(cutoffSections[1].color, AppColors.graphMediumValueColor.withOpacity(0.3));

    expect(cutoffSections[2].value, 100 - data.mediumPerformanceCutoff());
    expect(cutoffSections[2].color, AppColors.graphHighValueColor.withOpacity(0.3));
  });

  test('getting graph values for low performance', () async {
    //given
    var map = Mocks.ownerMyPortalDataResponse;
    map["company_performance"] = 40;
    var data = OwnerMyPortalData.fromJson(map);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var graphSections = presenter.getActualPerformanceGraphSections();

    //then
    expect(graphSections.length, 2);
    expect(graphSections[0].value, 40);
    expect(graphSections[0].color, AppColors.graphLowValueColor);
    expect(graphSections[1].value, 60);
    expect(graphSections[1].color, Colors.transparent);

    expect(presenter.getCompanyPerformance().value, 40);
    expect(presenter.getCompanyPerformance().color, AppColors.graphLowValueColor);
  });

  test('getting graph values for medium performance', () async {
    //given
    var map = Mocks.ownerMyPortalDataResponse;
    map["company_performance"] = 70;
    var data = OwnerMyPortalData.fromJson(map);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var graphSections = presenter.getActualPerformanceGraphSections();

    //then
    expect(graphSections.length, 3);
    expect(graphSections[0].value, data.lowPerformanceCutoff());
    expect(graphSections[0].color, AppColors.graphLowValueColor);
    expect(graphSections[1].value, 5);
    expect(graphSections[1].color, AppColors.graphMediumValueColor);
    expect(graphSections[2].value, 30);
    expect(graphSections[2].color, Colors.transparent);

    expect(presenter.getCompanyPerformance().value, 70);
    expect(presenter.getCompanyPerformance().color, AppColors.graphMediumValueColor);
  });

  test('getting graph values for high performance', () async {
    //given
    var map = Mocks.ownerMyPortalDataResponse;
    map["company_performance"] = 95;
    var data = OwnerMyPortalData.fromJson(map);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var graphSections = presenter.getActualPerformanceGraphSections();

    //then
    expect(graphSections.length, 4);
    expect(graphSections[0].value, data.lowPerformanceCutoff());
    expect(graphSections[0].color, AppColors.graphLowValueColor);
    expect(graphSections[1].value, data.mediumPerformanceCutoff() - data.lowPerformanceCutoff());
    expect(graphSections[1].color, AppColors.graphMediumValueColor);
    expect(graphSections[2].value, 16);
    expect(graphSections[2].color, AppColors.graphHighValueColor);
    expect(graphSections[3].value, 5);
    expect(graphSections[3].color, Colors.transparent);

    expect(presenter.getCompanyPerformance().value, 95);
    expect(presenter.getCompanyPerformance().color, AppColors.graphHighValueColor);
  });
}
