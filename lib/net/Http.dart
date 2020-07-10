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

class Http extends Dio {

  static Http instance;

  factory Http() {
    if (instance == null) {
      instance = Http._().._init();
    }
    return instance;
  }

  Http._();

  /// 初始化 加入app通用处理
  void _init() {
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors
    // 基础设置
      ..add(HeaderInterceptor())
    // JSON处理
      ..add(RespInterceptor())
    // cookie持久化 异步
      ..add(CookieManager(
          PersistCookieJar(dir: StorageManager.temporaryDirectory.path)));
  }
}

// 必须是顶层函数 (不明白为什么)
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class RespInterceptor extends Interceptor {
  static const baseUrl = 'https://www.wanandroid.com/';

  @override
  onRequest(RequestOptions options) {
    options.baseUrl = baseUrl;
    debugPrint("\n================== 请求数据 ==========================");
    debugPrint("url = ${options.uri.toString()}");
    debugPrint("headers = ${options.headers}");
    debugPrint("params = ${options.data}");
//    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
//        ' queryParameters: ${options.queryParameters}');
//    debugPrint('---api-request--->data--->${options.data}');
    return options;
  }

  @override
  onResponse(Response response) {
    debugPrint("\n================== 响应数据 ==========================");
    debugPrint("code = ${response.statusCode}");
    debugPrint("data = ${response.data}");
    if(response.statusCode != 200) {
      /// 非200会在http的onError()中
    } else {
      if (response.data is Map) {
        debugPrint('---api-response--->resp----->${response.data}');
        RespData respData = RespData.fromJson(response.data);
        if (respData.success) {
          response.data = respData.data;
          return http.resolve(response);
        } else {
          return handleFailed(respData);
        }
      } else {
        /// WanAndroid API 如果报错,返回的数据类型存在问题
        /// eg: 没有登录的返回的值为'{"errorCode":-1001,"errorMsg":"请先登录！"}'
        /// 虽然是json样式,但是[response.headers.contentType?.mimeType]的值为'text/html'
        /// 导致dio没有解析为json对象.两种解决方案:
        /// 1.在post/get方法前加入泛型(Map),让其强制转换
        /// 2.在这里统一处理再次解析
        debugPrint('---api-response--->error--not--map---->$response');
        RespData respData = RespData.fromJson(json.decode(response.data));
        return handleFailed(respData);
      }
    }
  }

  @override
  FutureOr<dynamic> onError(DioError e) {
    debugPrint("\n================== 错误响应数据 ======================");
    debugPrint("type = ${e.type}");
    debugPrint("message = ${e.message}");
    debugPrint("stackTrace = ${e.stackTrace}");
    debugPrint("\n");
  }

  Future<Response> handleFailed(RespData respData) {
    debugPrint('---api-response--->error---->$respData');
    if (respData.errorCode == -1001) {
      // 由于cookie过期,所以需要清除本地存储的登录信息
//      StorageManager.localStorage.deleteItem(UserModel.keyUser);
      // 需要登录
      throw const UnAuthorizedException();
    }
    return http.reject(respData.errorMsg);
  }


}