
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

/// 导航返回拦截（WillPopScope）
/// 2秒内再次按返回键退出
class QuitWillPopScope extends StatefulWidget {
  final child;

  QuitWillPopScope({this.child});

  @override
  State<StatefulWidget> createState() {
    return _QuitWillPopScopeState();
  }

}

class _QuitWillPopScopeState extends State<QuitWillPopScope> {
  DateTime _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            showToast("2秒内再次按返回键退出");
            return false;
          }
          return true;
        },
        child: widget.child
    );
  }
}