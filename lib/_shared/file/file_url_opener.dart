import 'package:url_launcher/url_launcher_string.dart';

class FileUrlOpener {
  static void openFileUrl(String? url) async {
    if (url != null) {
      var canLaunch = await canLaunchUrlString(url);
      if (canLaunch) launchUrlString(url);
    }
  }
}
