import 'package:flutter/material.dart';

///使用Stack和Positioned来实现绝对定位，
///Stack允许子widget堆叠，而Positioned可以给子widget定位（根据Stack的四个角）
class StackTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateTestState();
  }
}

class StateTestState extends State<StackTest> {
  @override
  Widget build(BuildContext context) {
    return //通过ConstrainedBox来确保Stack占满屏幕
      ConstrainedBox(
        //生成一个尽可能大的用以填充另一个容器的BoxConstraints
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
          fit: StackFit.expand, //未定位widget占满Stack整个空间
          children: <Widget>[
            Container(
              child: Text("Hello world", style: TextStyle(color: Colors.white),),
              color: Colors.red,
            ),
            Positioned(
              left: 18,
              child: Text("I am Jack"),
            ),
            Positioned(
              top: 18.0,
              child: Text("Your friend"),
            ),
          ],
        ),
      );
  }
}