import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

class MyConfig {
  static Future<bool> isValidVersion() async {
    final remoteConfig = RemoteConfig.instance;
    final packageInfo = await PackageInfo.fromPlatform();
    final versionText = packageInfo.version;
    final buildVersionText = packageInfo.buildNumber;
    final currentVersion = Version.parse('$versionText+$buildVersionText');

    final appVersionKey = Platform.isAndroid
        ? 'android_required_version'
        : 'ios_required_version';
    final defaultValues = <String, dynamic>{
      appVersionKey: versionText,
    };

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 0),
            minimumFetchInterval: const Duration(seconds: 0)),
      );
      await remoteConfig.setDefaults(defaultValues);
      await remoteConfig.fetchAndActivate();
      final requiredVersion =
          Version.parse(remoteConfig.getString(appVersionKey));
      return Future.value(
          !currentVersion.compareTo(requiredVersion).isNegative);
    } catch (e) {
      print('RemoteCongigError: $e');
      return Future.value(true);
    }
  }
}
