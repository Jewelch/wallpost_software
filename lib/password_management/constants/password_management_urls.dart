import 'package:wallpost/_shared/constants/base_urls.dart';

class PasswordManagementUrls {
  static String passwordResetterUrl() {
    return '${BaseUrls.baseUrlV2}/resetPassword?';
  }

  static String changePasswordUrl(String companyId) {
    return '${BaseUrls.baseUrlV2}/companies/$companyId/users/password?';
  }
}
