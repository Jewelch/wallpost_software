import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class DeviceInfoProvider {
  Future<String> getDeviceOS() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      return 'Android $release (SDK $sdkInt)';
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      return '$systemName $version';
    } else {
      return 'Unidentified OS';
    }
  }

  Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      return '$manufacturer $model';
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var name = iosInfo.name;
      var model = iosInfo.model;
      return '$name $model';
    } else {
      return 'Unidentified Device';
    }
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return 'v${version}b$buildNumber';
  }

  Future<String> getDeviceId() async {
    return 'deviceId';//TODO: get from local store
  }
}
