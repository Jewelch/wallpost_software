import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/contracts/main_view.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/password_management/entities/reset_password_form.dart';
import 'package:wallpost/password_management/services/password_resetter.dart';
import 'package:wallpost/password_management/ui/contracts/forgot_password_view.dart';
import 'package:wallpost/password_management/ui/presenters/forgot_password_presenter.dart';

import '../_mocks/mock_network_adapter.dart';

class MockMainView extends Mock implements MainView {}

class MockCurrentUserProvider extends Mock implements CurrentUserProvider {}

class MockSelectCompanyProvider extends Mock implements SelectedCompanyProvider {}

void main() {
  var view = MockMainView();
  var currentUserProvider = MockCurrentUserProvider();
  var selectCompanyProvider = MockSelectCompanyProvider();


  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(selectCompanyProvider);
  }



}
