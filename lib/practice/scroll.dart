import 'package:flutter/material.dart';

import 'UpdateItemModel.dart';

void main() => runApp(MyScrollApp());

class MyScrollApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAPPState();
  }
}

class MyAPPState extends State<MyScrollApp> {
  ScrollController _controller; //ListView 控制器
  bool isToTop = false; // 标示目前是否需要启用 "Top" 按钮
  @override
  void initState() {
    _controller = ScrollController();
    /*_controller.addListener(() {
      // 为控制器注册滚动监听方法
      if (_controller.offset > 1000) {
        // 如果 ListView 已经向下滚动了 1000，则启用 Top 按钮
        setState(() {
          isToTop = true;
        });
      } else if (_controller.offset < 300) {
        // 如果 ListView 向下滚动距离不足 300，则禁用 Top 按钮
        setState(() {
          isToTop = false;
        });
      }
    });*/
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NotificationListener Demo",
      home: Scaffold(
        appBar: AppBar(
          title: Text("NotificationListener Title"),
        ),
        body: UpdatedItem(),
        /*Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  print("ScrollStartNotification");
                } else if (scrollNotification is ScrollUpdateNotification) {
                  var pixels = scrollNotification.metrics.pixels;
                  if (pixels > 1000) {
                    // 如果 ListView 已经向下滚动了 1000，则启用 Top 按钮
                    setState(() {
                      isToTop = true;
                    });
                  } else if (pixels < 300) {
                    // 如果 ListView 向下滚动距离不足 300，则禁用 Top 按钮
                    setState(() {
                      isToTop = false;
                    });
                  }
                  print("ScrollUpdateNotification");
                } else if (scrollNotification is ScrollEndNotification) {
                  print("ScrollEndNotification");
                }
                return true;
              },
              child: ListView.builder(
                controller: _controller, // 初始化传入控制器
                itemCount: 30, // 列表元素总数
                itemBuilder: (context, index) =>
                    ListTile(title: Text("Index : $index")), // 列表项构造方法
              ),
            ),
            // 顶部 Top 按钮，根据 isToTop 变量判断是否需要注册滚动到顶部的方法
            Container(
                child: RaisedButton(
                  onPressed: (isToTop
                      ? () {
                          if (isToTop) {
                            _controller.animateTo(.0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease); // 做一个滚动到顶部的动画
                          }
                        }
                      : null),
                  child: Text("Top"),
                ),
                alignment: AlignmentDirectional.topCenter),
          ],
        ),*/
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 销毁控制器
    super.dispose();
  }
}
