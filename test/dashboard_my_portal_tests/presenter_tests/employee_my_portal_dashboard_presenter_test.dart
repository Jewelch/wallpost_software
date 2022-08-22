import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/dashboard_my_portal/entities/employee_my_portal_data.dart';
import 'package:wallpost/dashboard_my_portal/services/employee_my_portal_data_provider.dart';
import 'package:wallpost/dashboard_my_portal/ui/presenters/employee_my_portal_dashboard_presenter.dart';
import 'package:wallpost/dashboard_my_portal/ui/view_contracts/employee_my_portal_view.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../../expense_list_tests/services_tests/expense_list_provider_test.dart';
import '../mocks.dart';

class MockEmployeeMyPortalView extends Mock implements EmployeeMyPortalView {}

class MockAggregatedApproval extends Mock implements AggregatedApproval {}

class MockEmployeeMyPortalData extends Mock implements EmployeeMyPortalData {}

class MockEmployeeMyPortalDataProvider extends Mock implements EmployeeMyPortalDataProvider {}

void main() {
  late MockEmployeeMyPortalView view;
  late MockEmployeeMyPortalDataProvider dataProvider;
  late MockSelectedCompanyProvider companyProvider;
  late EmployeeMyPortalDashboardPresenter presenter;

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
    verifyNoMoreInteractions(companyProvider);
  }

  setUp(() {
    view = MockEmployeeMyPortalView();
    dataProvider = MockEmployeeMyPortalDataProvider();
    companyProvider = MockSelectedCompanyProvider();
    var company = MockCompany();
    when(() => company.id).thenReturn("someCompanyId");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
    presenter = EmployeeMyPortalDashboardPresenter.initWith(view, dataProvider, companyProvider);
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
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(MockEmployeeMyPortalData()));

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

  test('getting total approval count', () async {
    //given
    var approval1 = MockAggregatedApproval();
    var approval2 = MockAggregatedApproval();
    var approval3 = MockAggregatedApproval();
    when(() => approval1.approvalCount).thenReturn(3);
    when(() => approval2.approvalCount).thenReturn(4);
    when(() => approval3.approvalCount).thenReturn(23);
    var data = MockEmployeeMyPortalData();
    when(() => data.aggregatedApprovals).thenReturn([approval1, approval2, approval3]);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //then
    expect(presenter.getTotalApprovalCount(), 30);
  });

  test('getting cutoff graph sections', () async {
    //given
    var data = EmployeeMyPortalData.fromJson(Mocks.employeeMyPortalDataResponse);
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //when
    var cutoffSections = presenter.getCutoffPerformanceGraphSections();

    //then
    expect(cutoffSections[0].value, data.lowPerformanceCutoff());
    expect(cutoffSections[0].color, AppColors.red.withOpacity(0.3));

    expect(cutoffSections[1].value, data.mediumPerformanceCutoff() - data.lowPerformanceCutoff());
    expect(cutoffSections[1].color, AppColors.yellow.withOpacity(0.3));

    expect(cutoffSections[2].value, 100 - data.mediumPerformanceCutoff());
    expect(cutoffSections[2].color, AppColors.green.withOpacity(0.3));
  });

  group('tests for getting ytd performance graph values', () {
    test('getting graph values for low ytd performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["ytd_performance"] = 40;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //when
      var graphSections = presenter.getActualPerformanceGraphSections();

      //then
      expect(graphSections.length, 2);
      expect(graphSections[0].value, 40);
      expect(graphSections[0].color, AppColors.red);
      expect(graphSections[1].value, 60);
      expect(graphSections[1].color, Colors.transparent);

      expect(presenter.getYTDPerformance().value, 40);
      expect(presenter.getYTDPerformance().color, AppColors.red);
    });

    test('getting graph values for medium ytd performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["ytd_performance"] = 70;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //when
      var graphSections = presenter.getActualPerformanceGraphSections();

      //then
      expect(graphSections.length, 3);
      expect(graphSections[0].value, data.lowPerformanceCutoff());
      expect(graphSections[0].color, AppColors.red);
      expect(graphSections[1].value, 5);
      expect(graphSections[1].color, AppColors.yellow);
      expect(graphSections[2].value, 30);
      expect(graphSections[2].color, Colors.transparent);

      expect(presenter.getYTDPerformance().value, 70);
      expect(presenter.getYTDPerformance().color, AppColors.yellow);
    });

    test('getting graph values for high ytd performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["ytd_performance"] = 95;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //when
      var graphSections = presenter.getActualPerformanceGraphSections();

      //then
      expect(graphSections.length, 4);
      expect(graphSections[0].value, data.lowPerformanceCutoff());
      expect(graphSections[0].color, AppColors.red);
      expect(graphSections[1].value, data.mediumPerformanceCutoff() - data.lowPerformanceCutoff());
      expect(graphSections[1].color, AppColors.yellow);
      expect(graphSections[2].value, 16);
      expect(graphSections[2].color, AppColors.green);
      expect(graphSections[3].value, 5);
      expect(graphSections[3].color, Colors.transparent);

      expect(presenter.getYTDPerformance().value, 95);
      expect(presenter.getYTDPerformance().color, AppColors.green);
    });
  });

  group('tests for getting current month performance value', () {
    test('getting current month performance value for low performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["current_month_performance"] = 40;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //then
      expect(presenter.getCurrentMonthPerformance().value, 40);
      expect(presenter.getCurrentMonthPerformance().color, AppColors.red);
    });

    test('getting current month performance value for medium performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["current_month_performance"] = 70;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //then
      expect(presenter.getCurrentMonthPerformance().value, 70);
      expect(presenter.getCurrentMonthPerformance().color, AppColors.yellow);
    });

    test('getting current month performance value for high performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["current_month_performance"] = 95;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //then
      expect(presenter.getCurrentMonthPerformance().value, 95);
      expect(presenter.getCurrentMonthPerformance().color, AppColors.green);
    });
  });

  group('tests for getting current month attendance performance value', () {
    test('getting current month attendance performance value for low performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["current_month_attendance_percentage"] = 40;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //then
      expect(presenter.getCurrentMonthAttendancePerformance().value, 40);
      expect(presenter.getCurrentMonthAttendancePerformance().color, AppColors.red);
    });

    test('getting current month attendance performance value for medium performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["current_month_attendance_percentage"] = 70;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //then
      expect(presenter.getCurrentMonthAttendancePerformance().value, 70);
      expect(presenter.getCurrentMonthAttendancePerformance().color, AppColors.yellow);
    });

    test('getting current month attendance performance value for high performance', () async {
      //given
      var map = Mocks.employeeMyPortalDataResponse;
      map["current_month_attendance_percentage"] = 95;
      var data = EmployeeMyPortalData.fromJson(map);
      when(() => dataProvider.isLoading).thenReturn(false);
      when(() => dataProvider.get()).thenAnswer((_) => Future.value(data));
      await presenter.loadData();

      //then
      expect(presenter.getCurrentMonthAttendancePerformance().value, 95);
      expect(presenter.getCurrentMonthAttendancePerformance().color, AppColors.green);
    });
  });
}
