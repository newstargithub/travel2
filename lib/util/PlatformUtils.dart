
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

/// 是否是生产环境
const bool inProduction = const bool.fromEnvironment("dart.vm.product");

class PlatformUtils {

  /// 版本名 versionName CFBundleShortVersionString
  static Future<String> getAppVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// 版本号 versionCode CFBundleVersion
  static Future<String> getBuildNum() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  /// 平台系统
  static getPlatform() {
    if (defaultTargetPlatform == TargetPlatform.iOS){
      return "iOS";
    }
    return "Android";
  }
}