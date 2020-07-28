import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// web_view_page.dart 使用第三方库，在遇到 http 或者 https 的协议时，使用该页面去打开

class CommonWebViewPage extends StatelessWidget {

  final String url;

  /// 构造函数
  CommonWebViewPage({Key key, this.url}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    //使用第三方库 flutter_webview_plugin 来打开具体的网页地址
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
    );
  }

}