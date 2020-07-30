import 'package:flutter/material.dart';
import 'package:roll_demo/pages/common/web_view_page.dart';
import 'package:roll_demo/pages/home/home_page.dart';
import 'package:roll_demo/pages/user/TabUserPage.dart';
import 'package:roll_demo/pages/user/index.dart';

/// Scheme 是一种 APP 内跳转协议，通过 Scheme 协议在 APP 内实现一些页面的互相跳转。一般可以使用以下格式协议。
/// [scheme]://[host]/[path]?[query]
///

class Router {
  Pattern appScheme = "tyfapp";

  /// 注册路由事件
  Map<String, Widget Function(BuildContext)> registerRouter() {
    return {
      'homepage': (context) => _buildPage(HomePageIndex()),
      'userpage': (context) => _buildPage(UserPageIndex())
    };
  }

  /// 执行页面跳转
  void push(BuildContext context, String url) {
    Map<String, dynamic> urlParseRet = _parseUrl(url);
    // 不同页面，则跳转
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, urlParseRet);
    }));
  }

  /// 执行页面跳转
  void pushNamedAndRemoveUntil(BuildContext context, String url) {
    Map<String, dynamic> urlParseRet = _parseUrl(url);
    Navigator.pushNamedAndRemoveUntil(context, urlParseRet['action'].toString(),
        (route) {
      //判断是否为当前页面，如果是则返回 false，否则返回 true
      if (route.settings.name == urlParseRet['action'].toString()) {
        return false;
      }
      return true;
    }, arguments: urlParseRet['params']);
  }

  /// 解析跳转的url，并且分析其内部参数
  /// 使用 ? 来分割 path 和参数两部分，再使用 & 来获取参数的 key 和 value。解析出 path 和页面参数后，
  /// 我们需要根据具体的 path 来跳转到相应的组件页面，并将解析出来的页面参数带入到组件中
  Map<String, dynamic> _parseUrl(String url) {
    if (url.startsWith(appScheme)) {
      url = url.substring(9);
    }
    int placeIndex = url.indexOf('?');
    if (url == '' || url == null) {
      return {'action': '/', 'params': null};
    }
    if (placeIndex < 0) {
      return {'action': url, 'params': null};
    }
    String action = url.substring(0, placeIndex);
    String paramStr = url.substring(placeIndex + 1);
    if (paramStr == null) {
      return {'action': action, 'params': null};
    }
    Map params = {};
    List<String> paramsStrArr = paramStr.split('&');
    for (String singleParamsStr in paramsStrArr) {
      List<String> singleParamsArr = singleParamsStr.split('=');
      params[singleParamsArr[0]] = singleParamsArr[1];
    }
    return {'action': action, 'params': params};
  }

  /// 根据url处理获得需要跳转的action页面以及需要携带的参数
  Widget _getPage(String url, Map<String, dynamic> urlParseRet) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
      return CommonWebViewPage(url: url);
    } else if (url.startsWith(appScheme)) {
      // 判断是否解析出 path action，并且能否在路由配置中找到
      String pathAction = urlParseRet['action'].toString();
      switch (pathAction) {
        case "homepage":
          {
            return _buildPage(HomePageIndex());
          }
        case "userpage":
          {
            // 必要性检查，如果没有参数则不做任何处理
            if (urlParseRet['params']['user_id'].toString() == null) {
              return null;
            }
            return _buildPage(UserPageIndex(
                userId: urlParseRet['params']['user_id'].toString()));
          }
        default:
          {
            return _buildPage(HomePageIndex());
          }
      }
    }
    return null;
  }

  Widget _buildPage(Widget pageWidget) {

  }
}
