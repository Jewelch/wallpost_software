import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';
import 'package:wallpost/company_core/repositories/company_repository.dart';

class UserCompaniesRemover {
  late CompanyRepository _companyRepository;
  late AllowedActionsRepository _allowedActionsRepository;

  UserCompaniesRemover() {
    _companyRepository = CompanyRepository.getInstance();
    _allowedActionsRepository = AllowedActionsRepository.getInstance();
  }

  UserCompaniesRemover.initWith(
      CompanyRepository companyRepository, AllowedActionsRepository allowedActionsRepository) {
    _companyRepository = companyRepository;
    _allowedActionsRepository = allowedActionsRepository;
  }

  void removeCompaniesForUser(User user) {
    _companyRepository.removeCompaniesForUser(user);
    _allowedActionsRepository.removeAllAllowedActions();
  }
}
