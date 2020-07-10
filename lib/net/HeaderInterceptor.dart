
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:roll_demo/util/PlatformUtils.dart';

/// 添加常用Header
class HeaderInterceptor extends Interceptor {
  @override
  Future<FutureOr> onRequest(RequestOptions options) async {
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;

    var appVersion = await PlatformUtils.getAppVersion();
    var version = Map()
      ..addAll({
        'appVerison': appVersion,
      });
    options.headers['version'] = version;
    options.headers['platform'] = PlatformUtils.getPlatform();
    return options;
  }
}