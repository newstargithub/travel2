import 'package:flutter/material.dart';
/// Padding可以给其子节点添加补白（填充）
/// EdgeInsets定义了一些设置补白的便捷方法
class PaddingTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaddingTestState();
  }
}

class PaddingTestState extends State<PaddingTest> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      //上下左右各添加16像素补白
      padding: EdgeInsets.all(16),
      child: Column(
        //显式指定对齐方式为左对齐，排除对齐干扰
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            //左边添加8像素补白
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Hello world"),
          ),
          Padding(
            //上下各添加8像素补白
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("I am Jack"),
          ),
          Padding(
            //左边添加8像素补白
            padding: EdgeInsets.fromLTRB(12.0, 8.0, 10.0, 6.0),
            child: Text("Your friend"),
          ),
        ],
      ),
    );
  }
}
