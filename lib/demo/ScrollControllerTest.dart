import 'package:flutter/material.dart';

/// 判断当前位置是否超过1000像素，如果超过则在屏幕右下角显示一个“返回顶部”的按钮，
/// 该按钮点击后可以使ListView恢复到初始位置；如果没有超过1000像素，则隐藏“返回顶部”按钮。
class ScrollControllerTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScrollControllerTestState();
  }
}

class ScrollControllerTestState extends State<ScrollControllerTest> {
  ScrollController _controller = ScrollController();
  bool showToTopBtn = false;

  DateTime _lastPressedAt; //上次点击时间

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print(_controller.offset); //打印滚动位置
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && !showToTopBtn) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //该回调需要返回一个Future对象，如果返回的Future最终值为false时，则当前路由不出栈(不会返回)；最终值为true时，当前路由出栈退出。
      onWillPop: () async {
        if(_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          _lastPressedAt = DateTime.now();
          return false;
        }
        //1秒内连续按两次返回键退出
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("滚动控制")),
        body: Scrollbar(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("$index"),
              );
            },
            itemCount: 100,
            itemExtent: 50.0, //列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
            controller: _controller,
          ),
        ),
        floatingActionButton: !showToTopBtn
            ? null
            : FloatingActionButton(
                child: Icon(Icons.arrow_upward),
                onPressed: () {
                  //返回到顶部时执行动画
                  _controller.animateTo(.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                }),
      ),
    );
  }
}
