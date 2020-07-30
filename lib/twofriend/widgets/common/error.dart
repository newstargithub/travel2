import 'package:flutter/material.dart';

class CommonError extends StatelessWidget {
  /// 具体的错误码
  final String errorCode;

  /// 可点击的回调函数
  final Function action;

  /// 默认构造函数
  const CommonError({Key key, this.errorCode, this.action}) : super(key: key);

  /// 返回提示信息
  static const errorMapping = {
    'server_error': '服务器响应错误',
    'error': '系统异常',
    'default': '服务异常'
  };

  @override
  Widget build(BuildContext context) {
    String newErrorCode = errorCode;
    Function newAction = action;
    // 获取来自接口 router 跳转参数
    if (ModalRoute.of(context).settings.arguments != null) {
      //router 跳转的参数是通过 ModalRoute.of(context).settings.arguments 方法来获取
      var arguments = ModalRoute.of(context).settings.arguments;
      Map dataInfo = JsonConfig.objectToMap(arguments);
      if(dataInfo['errorCode'] != null) {
        newErrorCode = dataInfo['errorCode'] as String;
      }
      if(dataInfo['action'] != null) {
        newAction = dataInfo['action'] as Function;
      }
    }
    // 判断是否存在，不存在使用默认提示
    if(errorMapping[newErrorCode] == null) {
      newErrorCode = 'default';
    }
    return new Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${errorMapping[newErrorCode]}'),
            RaisedButton(
              color: Colors.lightBlueAccent,
              highlightColor: Colors.lightBlueAccent[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.lightBlueAccent,
              child: Icon(Icons.refresh),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                if (newAction != null) {
                  newAction(); // 处理重试
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
