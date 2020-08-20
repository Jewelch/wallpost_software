import 'package:wallpost/_shared/constants/base_urls.dart';

class PasswordManagementUrls {
  static String passwordResetterUrl() {
    return '${BaseUrls.BASE_URL_V2}/resetPassword?';
  }

  static String changePasswordUrl(String companyId) {
    return '${BaseUrls.BASE_URL_V2}/companies/$companyId/users/password?';
  }
}
