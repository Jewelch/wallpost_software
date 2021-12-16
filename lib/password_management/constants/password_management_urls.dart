// @dart=2.9

import 'package:wallpost/_shared/constants/base_urls.dart';

class PasswordManagementUrls {
  static String resetPasswordUrl() {
    return '${BaseUrls.baseUrlV2()}/resetPassword?';
  }

  static String changePasswordUrl() {
    return '${BaseUrls.baseUrlV2()}/changePassword?';
  }
}
