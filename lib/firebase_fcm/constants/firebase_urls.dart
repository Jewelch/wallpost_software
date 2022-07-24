import 'package:wallpost/_shared/constants/base_urls.dart';

class FirebaseUrls {
  static String updateTokenUrl() {
    return '${BaseUrls.baseUrlV2()}/device/token';
  }
}
