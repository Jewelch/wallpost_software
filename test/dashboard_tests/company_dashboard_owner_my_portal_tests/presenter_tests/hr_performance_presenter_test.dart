import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/entities/hr_dashboard_data.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/services/hr_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/models/owner_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/presenters/hr_performance_presenter.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';

class MockModulePerformanceView extends Mock implements ModulePerformanceView {}

class MockHRDataProvider extends Mock implements HRDashboardDataProvider {}

class MockHRData extends Mock implements HRDashboardData {}

void main() {
  var filters = OwnerDashboardFilters();
  var view = MockModulePerformanceView();
  var dataProvider = MockHRDataProvider();
  late HRPerformancePresenter presenter;

  setUp(() {
    presenter = HRPerformancePresenter.initWith(view, filters, dataProvider);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(dataProvider);
  }

  test('loading data when service is loading does nothing', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(true);

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
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.showErrorMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('successfully loading the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(MockHRData()));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => dataProvider.isLoading,
      () => view.showLoader(),
      () => dataProvider.get(month: any(named: "month"), year: any(named: "year")),
      () => view.onDidLoadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('error message is reset before getting the data', () async {
    //given
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    presenter.loadData();

    expect(presenter.errorMessage, "");
  });

  test("get active staff", () async {
    var data = MockHRData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.activeStaff).thenReturn("1,234");
    expect(presenter.getActiveStaff().label, "Active Staff");
    expect(presenter.getActiveStaff().value, "1,234");
    expect(presenter.getActiveStaff().textColor, AppColors.green);
  });

  test("get employee cost", () async {
    var data = MockHRData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    when(() => data.employeeCost).thenReturn("12,434");
    expect(presenter.getEmployeeCost().label, "Employee Cost");
    expect(presenter.getEmployeeCost().value, "12,434");
    expect(presenter.getEmployeeCost().textColor, AppColors.green);
  });

  test("get staff on leave", () async {
    var data = MockHRData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //no staff on leave
    when(() => data.staffOnLeaveToday).thenReturn("0");
    when(() => data.isAnyStaffOnLeave()).thenReturn(false);
    expect(presenter.getStaffOnLeaveToday().label, "Staff On Leave");
    expect(presenter.getStaffOnLeaveToday().value, "0");
    expect(presenter.getStaffOnLeaveToday().textColor, AppColors.green);

    //some staff on leave
    when(() => data.staffOnLeaveToday).thenReturn("3");
    when(() => data.isAnyStaffOnLeave()).thenReturn(true);
    expect(presenter.getStaffOnLeaveToday().label, "Staff On Leave");
    expect(presenter.getStaffOnLeaveToday().value, "3");
    expect(presenter.getStaffOnLeaveToday().textColor, AppColors.red);
  });

  test("get expired documents", () async {
    var data = MockHRData();
    when(() => dataProvider.isLoading).thenReturn(false);
    when(() => dataProvider.get(month: any(named: "month"), year: any(named: "year")))
        .thenAnswer((_) => Future.value(data));
    await presenter.loadData();

    //no expired documents
    when(() => data.documentsExpired).thenReturn("0");
    when(() => data.areAnyDocumentsExpired()).thenReturn(false);
    expect(presenter.getDocumentsExpired().label, "Expired Documents");
    expect(presenter.getDocumentsExpired().value, "0");
    expect(presenter.getDocumentsExpired().textColor, AppColors.green);

    //some staff on leave
    when(() => data.documentsExpired).thenReturn("3");
    when(() => data.areAnyDocumentsExpired()).thenReturn(true);
    expect(presenter.getDocumentsExpired().label, "Expired Documents");
    expect(presenter.getDocumentsExpired().value, "3");
    expect(presenter.getDocumentsExpired().textColor, AppColors.red);
  });
}
