import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/IRespData.dart';

typedef Converter = IRespData Function(dynamic);

/// 拦截者
class ApiInterceptor extends Interceptor {

  Converter converter;

  @override
  onRequest(RequestOptions options) {
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
    if (response.statusCode != 200) {
      ///非200会在http的onError()中
    } else {
      debugPrint('---api-response--->resp----->${response.data}');
      if(converter == null) {
        return Dio().resolve(response);
      }
      IRespData respData = converter(response.data);
      if (respData.success) {
        response.data = respData.data;
        return Dio().resolve(response);
      } else {
        debugPrint('---api-response--->error---->$respData');
        return Dio().reject(respData.errorMsg);
      }
    }
  }
}