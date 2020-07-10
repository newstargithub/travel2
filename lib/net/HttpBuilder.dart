import 'dart:io';

import 'package:dio/dio.dart';
import 'package:roll_demo/util/PlatformUtils.dart';
import 'ApiInterceptor.dart';

class HttpBuilder {
  String _baseUrl;
  int connectTimeout = 5000;
  int receiveTimeout = 5000;
  Interceptors _interceptorList;
  Converter _converter;

  HttpBuilder baseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  HttpBuilder addInterceptor(Interceptor interceptor) {
    _interceptorList.add(interceptor);
    return this;
  }

  HttpBuilder converter(Converter converter) {
    _converter = converter;
    return this;
  }

  Dio build() {
    var version = PlatformUtils.getAppVersion();
    var platform = PlatformUtils.getPlatform();
    var dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        HttpHeaders.userAgentHeader: 'dio',
        'version': version,
        'platform': platform
      },
    ));
    var apiInterceptor = ApiInterceptor();
    apiInterceptor.converter = _converter;
    dio.interceptors.add(apiInterceptor);
    if (_interceptorList != null && _interceptorList.isNotEmpty) {
      dio.interceptors.addAll(_interceptorList);
    }
    return dio;
  }
}
