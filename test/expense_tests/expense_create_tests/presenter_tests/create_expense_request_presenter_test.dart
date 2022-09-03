import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense/expense_create/entities/expense_category.dart';
import 'package:wallpost/expense/expense_create/entities/expense_request_form.dart';
import 'package:wallpost/expense/expense_create/services/expense_categories_provider.dart';
import 'package:wallpost/expense/expense_create/services/expense_request_creator.dart';
import 'package:wallpost/expense/expense_create/ui/presenters/create_expense_request_presenter.dart';
import 'package:wallpost/expense/expense_create/ui/view_contracts/create_expense_request_view.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_file.dart';
import '../../../_mocks/mock_network_adapter.dart';

class MockExpenseCategory extends Mock implements ExpenseCategory {}

class MockExpenseRequestForm extends Mock implements ExpenseRequestForm {}

class MockCreateExpenseRequestView extends Mock implements CreateExpenseRequestView {}

class MockExpenseCategoriesProvider extends Mock implements ExpenseCategoriesProvider {}

class MockExpenseRequestCreator extends Mock implements ExpenseRequestCreator {}

void main() {
  late MockCreateExpenseRequestView view;
  late MockExpenseCategoriesProvider categoriesProvider;
  late MockExpenseRequestCreator requestCreator;
  late MockCompanyProvider companyProvider;
  late CreateExpenseRequestPresenter presenter;

  setUpAll(() {
    registerFallbackValue(MockExpenseRequestForm());
  });

  setUp(() {
    view = MockCreateExpenseRequestView();
    categoriesProvider = MockExpenseCategoriesProvider();
    requestCreator = MockExpenseRequestCreator();
    companyProvider = MockCompanyProvider();
    presenter = CreateExpenseRequestPresenter.initWith(
      view,
      categoriesProvider,
      requestCreator,
      companyProvider,
    );

    var company = MockCompany();
    when(() => company.currency).thenReturn("USD");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(categoriesProvider);
    verifyNoMoreInteractions(requestCreator);
    verifyNoMoreInteractions(companyProvider);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(categoriesProvider);
    clearInteractions(requestCreator);
    clearInteractions(companyProvider);
  }

  group('tests for loading categories', () {
    test('loading categories when the provider is loading does nothing', () async {
      //given
      when(() => categoriesProvider.isLoading).thenReturn(true);

      //when
      await presenter.loadCategories();

      //then
      verifyInOrder([
        () => categoriesProvider.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('failure to load categories', () async {
      //given
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.loadCategories();

      //then
      expect(presenter.getLoadCategoriesError(),
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
      verifyInOrder([
        () => categoriesProvider.isLoading,
        () => view.showCategoriesLoader(),
        () => categoriesProvider.get(),
        () => view.onDidFailToLoadCategories(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully loading an empty list of categories', () async {
      //given
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([]));

      //when
      await presenter.loadCategories();

      //then
      expect(presenter.getLoadCategoriesError(), "There are no categories to show.\n\nTap here to reload.");
      verifyInOrder([
        () => categoriesProvider.isLoading,
        () => view.showCategoriesLoader(),
        () => categoriesProvider.get(),
        () => view.onDidFailToLoadCategories(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test(
        'successfully loading categories selects the main category when the category'
        'has no projects and sub categories', () async {
      //given
      var category = MockExpenseCategory();
      when(() => category.name).thenReturn("main category 1");
      when(() => category.projects).thenReturn([]);
      when(() => category.subCategories).thenReturn([]);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category]));

      //when
      await presenter.loadCategories();

      //then
      expect(presenter.getSelectedMainCategoryName(), "main category 1");
      verifyInOrder([
        () => categoriesProvider.isLoading,
        () => view.showCategoriesLoader(),
        () => categoriesProvider.get(),
        () => view.onDidLoadCategories(),
        () => view.onDidSelectMainCategory(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test(
        'successfully loading categories selects the main category when the'
        'category has projects and sub categories', () async {
      //given
      var category = MockExpenseCategory();
      var project = MockExpenseCategory();
      var subCategory = MockExpenseCategory();
      when(() => category.name).thenReturn("main category 1");
      when(() => project.name).thenReturn("project 1");
      when(() => subCategory.name).thenReturn("sub category 1");
      when(() => category.projects).thenReturn([project]);
      when(() => category.subCategories).thenReturn([subCategory]);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category]));

      //when
      await presenter.loadCategories();

      //then
      expect(presenter.getSelectedMainCategoryName(), "main category 1");
      expect(presenter.getSelectedProjectName(), "project 1");
      expect(presenter.getSelectedSubCategoryName(), "sub category 1");
      verifyInOrder([
        () => categoriesProvider.isLoading,
        () => view.showCategoriesLoader(),
        () => categoriesProvider.get(),
        () => view.onDidLoadCategories(),
        () => view.onDidSelectMainCategory(),
        () => view.onDidSelectProject(),
        () => view.onDidSelectSubCategory(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('get isLoadingExpenseCategories', () {
      when(() => categoriesProvider.isLoading).thenReturn(true);
      expect(presenter.isLoadingExpenseCategories(), true);

      when(() => categoriesProvider.isLoading).thenReturn(false);
      expect(presenter.isLoadingExpenseCategories(), false);
    });

    test("get shouldShowLoadCategoriesError is true when there is an error", () async {
      //given
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.loadCategories();

      //then
      expect(presenter.shouldShowLoadCategoriesError(), true);
    });

    test('get shouldShowLoadCategoriesError is false when there is no error', () async {
      //given
      var category = MockExpenseCategory();
      when(() => category.projects).thenReturn([]);
      when(() => category.subCategories).thenReturn([]);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category]));
      await presenter.loadCategories();

      //then
      expect(presenter.shouldShowLoadCategoriesError(), false);
    });
  });

  group("tests for functions to set the data", () {
    test("setting date", () {
      //when
      var date = DateTime(2022, 8, 20);
      presenter.setDate(date);

      //then
      expect(presenter.getDate(), date);
      expect(presenter.getDateString(), "20 Aug 2022");
      verifyInOrder([
        () => view.onDidSelectDate(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test(
        "test selecting main category when there the main category"
        "has no projects and sub categories", () async {
      //given
      var category1 = MockExpenseCategory();
      var category2 = MockExpenseCategory();
      when(() => category1.name).thenReturn("main category 1");
      when(() => category2.name).thenReturn("main category 2");
      when(() => category1.projects).thenReturn([]);
      when(() => category1.subCategories).thenReturn([]);
      when(() => category1.isDisabled).thenReturn(false);
      when(() => category2.isDisabled).thenReturn(false);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category1, category2]));
      await presenter.loadCategories();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectMainCategoryAtIndex(0);

      //then
      expect(presenter.getSelectedMainCategoryName(), "main category 1");
      expect(presenter.getSelectedSubCategoryName(), "");
      expect(presenter.getSelectedProjectName(), "");

      expect(presenter.getMainCategoryNames(), ["main category 1", "main category 2"]);
      expect(presenter.getDisabledMainCategoryNames(), []);
      expect(presenter.getProjectNamesForSelectedMainCategory(), []);
      expect(presenter.getSubCategoryNamesForSelectedMainCategory(), []);

      expect(presenter.shouldShowProjects(), false);
      expect(presenter.shouldShowSubCategories(), false);
      verifyInOrder([
        () => view.onDidSelectMainCategory(),
      ]);
    });

    test(
        "test selecting main category when there the main category"
        "has projects and sub categories", () async {
      //given
      var category1 = MockExpenseCategory();
      var category2 = MockExpenseCategory();
      var category3 = MockExpenseCategory();
      var project = MockExpenseCategory();
      var subCategory = MockExpenseCategory();
      when(() => category1.name).thenReturn("main category 1");
      when(() => category2.name).thenReturn("main category 2");
      when(() => category3.name).thenReturn("main category 3");
      when(() => project.name).thenReturn("project 1");
      when(() => subCategory.name).thenReturn("sub category 1");
      when(() => category1.projects).thenReturn([project]);
      when(() => category1.subCategories).thenReturn([subCategory]);
      when(() => category1.isDisabled).thenReturn(false);
      when(() => category2.isDisabled).thenReturn(false);
      when(() => category3.isDisabled).thenReturn(true);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category1, category2, category3]));
      await presenter.loadCategories();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectMainCategoryAtIndex(0);

      //then
      expect(presenter.getSelectedMainCategoryName(), "main category 1");
      expect(presenter.getSelectedProjectName(), "project 1");
      expect(presenter.getSelectedSubCategoryName(), "sub category 1");

      expect(presenter.getMainCategoryNames(), ["main category 1", "main category 2", "main category 3"]);
      expect(presenter.getDisabledMainCategoryNames(), ["main category 3"]);
      expect(presenter.getProjectNamesForSelectedMainCategory(), ["project 1"]);
      expect(presenter.getSubCategoryNamesForSelectedMainCategory(), ["sub category 1"]);

      expect(presenter.shouldShowProjects(), true);
      expect(presenter.shouldShowSubCategories(), true);
      verifyInOrder([
        () => view.onDidSelectMainCategory(),
        () => view.onDidSelectProject(),
        () => view.onDidSelectSubCategory(),
      ]);
    });

    test("test selecting a project", () async {
      //given
      var category = MockExpenseCategory();
      var project1 = MockExpenseCategory();
      var project2 = MockExpenseCategory();
      when(() => category.name).thenReturn("main category 1");
      when(() => project1.name).thenReturn("project 1");
      when(() => project2.name).thenReturn("project 2");
      when(() => category.projects).thenReturn([project1, project2]);
      when(() => category.subCategories).thenReturn([]);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category]));
      await presenter.loadCategories();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectProjectAtIndex(1);

      //then
      expect(presenter.getSelectedProjectName(), "project 2");
      verifyInOrder([
        () => view.onDidSelectProject(),
      ]);
    });

    test("test selecting a sub category", () async {
      //given
      var category = MockExpenseCategory();
      var subCategory1 = MockExpenseCategory();
      var subCategory2 = MockExpenseCategory();
      when(() => category.name).thenReturn("main category 1");
      when(() => subCategory1.name).thenReturn("sub category 1");
      when(() => subCategory2.name).thenReturn("sub category 2");
      when(() => category.projects).thenReturn([]);
      when(() => category.subCategories).thenReturn([subCategory1, subCategory2]);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category]));
      await presenter.loadCategories();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectSubCategoryAtIndex(1);

      //then
      expect(presenter.getSelectedSubCategoryName(), "sub category 2");
      verifyInOrder([
        () => view.onDidSelectSubCategory(),
      ]);
    });

    test("setting an invalid rate", () {
      //when
      presenter.setRate("invalid number");

      //then
      expect(presenter.getRateError(), "Please set a rate");
      expect(presenter.getTotalAmount(), "");
      verifyInOrder([
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting zero rate", () {
      //when
      presenter.setRate("0");

      //then
      expect(presenter.getRateError(), "Rate cannot be zero");
      expect(presenter.getTotalAmount(), "");
      verifyInOrder([
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting an invalid quantity", () {
      //when
      presenter.setQuantity("invalid quantity");

      //then
      expect(presenter.getQuantityError(), "Please set a quantity");
      expect(presenter.getTotalAmount(), "");
      verifyInOrder([
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting zero quantity", () {
      //when
      presenter.setQuantity("0");

      //then
      expect(presenter.getQuantityError(), "Quantity cannot be zero");
      expect(presenter.getTotalAmount(), "");
      verifyInOrder([
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting a valid rate and quantity", () {
      //when
      presenter.setRate("12.30");
      presenter.setQuantity("3");

      //then
      expect(presenter.getRateError(), null);
      expect(presenter.getQuantityError(), null);
      expect(presenter.getTotalAmount(), "USD 36.90");
      verifyInOrder([
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
        () => companyProvider.getSelectedCompanyForCurrentUser(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting a valid quantity", () {
      //when
      presenter.setQuantity("10");

      //then
      expect(presenter.getQuantityError(), null);
      verifyInOrder([
        () => view.updateValidationErrors(),
        () => view.updateTotalAmount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("adding an attachment", () {
      //given
      var file = MockFile();
      when(() => file.path).thenReturn("folder/filename.png");

      //when
      presenter.addAttachment(file);

      //then
      expect(presenter.getAttachedFileName(), "filename.png");
      verifyInOrder([
        () => view.onDidAddAttachment(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("removing an attachment", () {
      //given
      var file = MockFile();
      when(() => file.path).thenReturn("folder/filename.png");
      presenter.addAttachment(file);
      _clearInteractionsOnAllMocks();

      //when
      presenter.removeAttachment();

      //then
      expect(presenter.getAttachedFileName(), "");
      verifyInOrder([
        () => view.onDidRemoveAttachment(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting description", () {
      //when
      presenter.setDescription("some description");

      expect(presenter.getDescription(), "some description");
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group("tests for submitting the form", () {
    Future<void> _setupValidData() async {
      var category = MockExpenseCategory();
      var project = MockExpenseCategory();
      var subCategory = MockExpenseCategory();
      when(() => category.id).thenReturn("id1");
      when(() => project.id).thenReturn("id2");
      when(() => subCategory.id).thenReturn("id3");
      when(() => category.projects).thenReturn([project]);
      when(() => category.subCategories).thenReturn([subCategory]);
      when(() => categoriesProvider.isLoading).thenReturn(false);
      when(() => categoriesProvider.get()).thenAnswer((_) => Future.value([category]));
      await presenter.loadCategories();
      presenter.setDate(DateTime(2022, 8, 20));
      presenter.setRate("22.50");
      presenter.setQuantity("2");
      presenter.setDescription("some description");
      presenter.addAttachment(MockFile());
      _clearInteractionsOnAllMocks();
    }

    test("validation", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);
      _clearInteractionsOnAllMocks();

      //when
      await presenter.createExpenseRequest();

      //then
      expect(presenter.getRateError(), "Please set a rate");
      expect(presenter.getQuantityError(), "Please set a quantity");
      verify(() => requestCreator.isLoading).called(1);
      verify(() => view.updateValidationErrors()).called(2);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("does nothing when the request creator is loading", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(true);

      //when
      await presenter.createExpenseRequest();

      //then
      verifyInOrder([
        () => requestCreator.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("shows validation errors if input is invalid", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);

      //when
      await presenter.createExpenseRequest();

      //then
      verifyInOrder([
        () => requestCreator.isLoading,
        () => view.updateValidationErrors(),
        () => view.updateValidationErrors(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("failure to submit form", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);
      when(() => requestCreator.create(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));
      await _setupValidData();

      //when
      await presenter.createExpenseRequest();

      //then
      verifyInOrder([
        () => requestCreator.isLoading,
        () => view.updateValidationErrors(),
        () => view.updateValidationErrors(),
        () => view.showFormSubmissionLoader(),
        () => requestCreator.create(any(), any()),
        () => view.onDidFailToSubmitForm(
              "Failed to create expense request",
              InvalidResponseException().userReadableMessage,
            ),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("successfully submitting the form", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);
      when(() => requestCreator.create(any(), any())).thenAnswer((_) => Future.value(null));
      await _setupValidData();

      //when
      await presenter.createExpenseRequest();

      //then
      verifyInOrder([
        () => requestCreator.isLoading,
        () => view.updateValidationErrors(),
        () => view.updateValidationErrors(),
        () => view.showFormSubmissionLoader(),
        () => requestCreator.create(any(), any()),
        () => view.onDidSubmitFormSuccessfully("Success", "Your expense request has been submitted successfully."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("get isFormSubmissionInProgress", () {
      when(() => requestCreator.isLoading).thenReturn(false);
      expect(presenter.isFormSubmissionInProgress(), false);

      when(() => requestCreator.isLoading).thenReturn(true);
      expect(presenter.isFormSubmissionInProgress(), true);
    });
  });
}
