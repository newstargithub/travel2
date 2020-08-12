
import 'package:dio/dio.dart';
import 'package:roll_demo/net/ApiInterceptor.dart';

/// 接口规划 Dio的封装类
class ApiStrategy {
  static const int connectTimeOut = 10 * 1000; //连接超时时间为10秒
  static const int receiveTimeOut = 15 * 1000; //响应超时时间为15秒
  static const String GET = "get";
  static const String POST = "post";
  static final String baseUrl = "http://111.230.251.115/oldchen/";

  static ApiStrategy _instance;

  Dio _client;

  static ApiStrategy getInstance() {
    if (_instance == null) {
      _instance = ApiStrategy._internal();
    }
    return _instance;
  }

  ///私有构造函数
  ApiStrategy._internal() {
    BaseOptions options = BaseOptions();
    options.connectTimeout = connectTimeOut;
    options.receiveTimeout = receiveTimeOut;
    options.baseUrl = baseUrl;
    _client = Dio(options);
    //开启请求日志
    _client.interceptors.add(ApiInterceptor());
  }

  Dio get client => _client;

  static String getBaseUrl() {
    return baseUrl;
  }

  /// get请求
  void get(
      String url,
      Function callBack, {
        Map<String, String> params,
        Function errorCallBack,
        CancelToken token,
      }) async {
    _request(url,
        callBack,
        method: GET,
        params: params,
        errorCallback: errorCallBack,
        token: token);
  }

  /// post请求
  void post(
      String url,
      Function callBack, {
        Map<String, String> params,
        Function errorCallBack,
        ProgressCallback progressCallBack,
        CancelToken token,
      }) async {
    _request(url,
        callBack,
        method: POST,
        params: params,
        errorCallback: errorCallBack,
        progressCallback: progressCallBack,
        token: token);
  }

  /// 发送请求
  Future _request(String url, Function callBack, {
    String method,
    Map<String, String> params,
    FormData formData,
    Function errorCallback,
    ProgressCallback progressCallback,
    CancelToken token,
  }) async {
    String errorMsg = "";
    int statusCode;
    try {
      Response response;
      if(method == GET) {
        //组合GET请求的参数
        if (params != null && params.isNotEmpty) {
          response = await _client.get(url,
              queryParameters: params,
              cancelToken: token,
              onReceiveProgress: progressCallback);
        } else {
          response = await _client.get(url,
              cancelToken: token);
        }
      } else {
        if (params != null && params.isNotEmpty || formData.length != 0) {
          response = await _client.post(url,
              data: formData?? FormData.fromMap(params),
              cancelToken: token,
              onReceiveProgress: progressCallback);
        } else {
          response = await _client.post(url,
              cancelToken: token);
        }
      }
      statusCode = response.statusCode;
      //处理错误部分
      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(errorCallback, errorMsg);
        return;
      }
      if (callBack != null) {
        callBack(response.data);
      }
    } catch (e) {
      _handError(errorCallback, e.toString());
    }
  }

  void _handError(Function errorCallback, String errorMsg) {
    print("<net> errorMsg :" + errorMsg);
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }



}