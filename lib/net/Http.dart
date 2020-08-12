import 'dart:async';
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:roll_demo/bean/RespData.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:roll_demo/util/PlatformUtils.dart';

import 'HeaderInterceptor.dart';

final Http http = Http();

class Http  {

  static Http instance;
  var dio;

  factory Http() {
    if (instance == null) {
      instance = Http._().._init();
    }
    return instance;
  }

  Http._();

  /// 初始化 加入app通用处理
  void _init() {
    dio = Dio();
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    dio.interceptors
    // 基础设置
      ..add(HeaderInterceptor())
    // JSON处理
      ..add(RespInterceptor());
    // cookie持久化 异步
//      ..add(CookieManager(
//          PersistCookieJar(dir: StorageManager.temporaryDirectory.path)));
  }
}

// 必须是顶层函数 (不明白为什么)
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

/// 响应拦截器
class RespInterceptor extends Interceptor {
  static const baseUrl = 'https://www.wanandroid.com/';

  @override
  Future onRequest(RequestOptions options) {
    options.baseUrl = baseUrl;
    debugPrint("\n================== 请求数据 ==========================");
    debugPrint("url = ${options.uri.toString()}");
    debugPrint("headers = ${options.headers}");
    debugPrint("params = ${options.data}");
//    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
//        ' queryParameters: ${options.queryParameters}');
//    debugPrint('---api-request--->data--->${options.data}');
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    debugPrint("\n================== 响应数据 ==========================");
    debugPrint("code = ${response.statusCode}");
    debugPrint("data = ${response.data}");
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      return http.dio.resolve(response);
    } else {
      if (respData.code == -1001) {
        // 如果cookie过期,需要清除本地存储的登录信息
        // StorageManager.localStorage.deleteItem(UserModel.keyUser);
        throw const UnAuthorizedException(); // 需要登录
      } else {
        return handleFailed(respData);
      }
    }
  }

  Future onError(DioError err) {
    debugPrint("\n================== 错误响应数据 ======================");
    debugPrint("type = ${err.type}");
    debugPrint("message = ${err.message}");
    debugPrint("stackTrace = $err");
    debugPrint("\n");
  }

  Future<Response> handleFailed(ResponseData respData) {
    debugPrint('---api-response--->error---->$respData');
    if (respData.code == -1001) {
      // 由于cookie过期,所以需要清除本地存储的登录信息
//      StorageManager.localStorage.deleteItem(UserModel.keyUser);
      // 需要登录
      throw const UnAuthorizedException();
    }
    return http.dio.reject(respData.message);
  }


}

/// 子类需要重写
abstract class BaseResponseData {
  int code = 0;
  String message;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $message, data: $data}';
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 0 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['errorCode'];
    message = json['errorMsg'];
    data = json['data'];
  }
}