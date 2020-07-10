import 'package:flutter/material.dart';

///打开新路由页
void push(BuildContext context, Widget widget) {
  ///Navigator是一个路由管理的widget，它通过一个栈来管理一个路由widget集合。
  Navigator.of(context).push(
      ///MaterialPageRoute继承自PageRoute类，PageRoute类是一个抽象类，表示占有整个
      ///屏幕空间的一个模态路由页面，它还定义了路由构建及切换时过渡动画的相关接口及属性。
      new MaterialPageRoute(builder: (context) {
    return widget;
  }));
}

///通过路由名打开新路由页
Future<T> pushNamed<T extends Object>(BuildContext context, String routeName,
    {Object arguments, bool replace = false}) {
  if (replace) {
    return Navigator.of(context)
        .pushReplacementNamed(routeName, arguments: arguments);
  }
  return Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

/// 路由工具类
/// 最好统一使用命名路由的管理方式
class NavigatorUtils {

  /// 返回
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// 通过路由名打开新路由页
  /// 获取路由参数 var args = ModalRoute.of(context).settings.arguments;
  /// @param replace 替换路由 关闭当前页面
  static Future<T> pushNamed<T extends Object>(BuildContext context, String routeName,
      {Object arguments, bool replace = false}) {
    if (replace) {
      return Navigator.of(context)
          .pushReplacementNamed(routeName, arguments: arguments);
    }
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// 通过路由名打开新路由页,捕获返回值
  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    var result = await Navigator.of(context).pushNamed(path);
    // 路由返回值 返回result为null
    if (result == null){
      return;
    }
    function(result);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context, result);
  }
}
