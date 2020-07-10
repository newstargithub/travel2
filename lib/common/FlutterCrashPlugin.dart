
import 'package:flutter/services.dart';
/// 在原生工程中的 Flutter 应用入口注册原生代码宿主回调
///考虑到数据上报是整个应用共享的能力，
///因此我们将数据上报类 FlutterCrashPlugin 的接口都封装成了单例
class FlutterCrashPlugin {
  static const MethodChannel _channel = const MethodChannel("flutter_crash_plugin");

  static void setUp(appId) {
    //使用app_id进行SDK注册
    _channel.invokeMethod("setup", {"app_id":appId});
  }

  static void postException(error, stack) {
    _channel.invokeMethod("postException", {'crash_message':error.toString(), 'crash_detail':stack.toString()});
  }

}