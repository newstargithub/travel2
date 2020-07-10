
import 'package:flutter/services.dart';

class FlutterPluginNetwork {
  static const MethodChannel _channel = const MethodChannel("flutter_plugin_network");

  /// 接收请求 URL 和参数，并返回接口响应数据的方法
  static Future<String> doRequest(url, params)  async {
    //使用方法通道调用原生接口doRequest，传入URL和param两个参数
    final String result = await _channel.invokeMethod("doRequest", {
      url: url,
      params: params
    });
    return result;
  }


}