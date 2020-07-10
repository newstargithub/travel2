import 'package:flutter/material.dart';

/// ConstrainedBox用于对子widget添加额外的约束。
///
/// BoxConstraints用于设置限制条件
/// BoxConstraints.tight(Size size)，它可以生成给定大小的限制；
/// const BoxConstraints.expand()可以生成一个尽可能大的用以填充另一个容器的BoxConstraints。
/// SizedBox用于给子widget指定固定的宽高
///
/// 有多重限制时，对于minWidth和minHeight来说，是取父子中相应数值较大的。
class ConstrainedBoxTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConstrainedBoxTestState();
  }
}

class ConstrainedBoxTestState extends State<ConstrainedBoxTest> {
  //定义一个redBox，它是一个背景颜色为红色的盒子，不指定它的宽度和高度
  Widget redBox = DecoratedBox(decoration: BoxDecoration(color: Colors.red));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity, //宽度尽可能大
            minHeight: 50, //最小高度为50像素
          ),
          child: Container(
            height: 5,
            child: redBox,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 80,
          height: 80,
          child: redBox,
        ),
        SizedBox(height: 10),
        _buildDecoratedBox(),
        SizedBox(height: 10),
        _buildTransform(),
        SizedBox(height: 10),
        _buildRotatedBox(),
        SizedBox(height: 10),
        _buildContainer()
      ],
    );
  }

  /// DecoratedBox可以在其子widget绘制前(或后)绘制一个装饰(Decoration)如背景、边框、渐变等
  /// decoration：代表将要绘制的装饰，它类型为Decoration，Decoration是一个抽象类，它定义了一个接口 createBoxPainter()
  /// 通常会直接使用BoxDecoration，它是一个Decoration的子类，实现了常用的装饰元素的绘制。
  Widget _buildDecoratedBox() {
    return DecoratedBox(
        decoration: BoxDecoration(
            //背景渐变
            gradient: LinearGradient(colors: [Colors.red, Colors.orange[700]]),
            //3像素圆角
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              //阴影
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              )
            ]),
        position: DecorationPosition.background,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 18.0),
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  /// Transform可以在其子Widget绘制时对其应用一个矩阵变换（transformation）
  /// Transform.translate接收一个offset参数，可以在绘制时沿x、y轴对子widget平移指定的距离。
  ///
  /// Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，所以无论对子widget应用何种变化，
  /// 其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的。
  _buildTransform() {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.red),
      //默认原点为左上角，左移20像素，向上平移5像素
      child: Transform.translate(
        offset: Offset(-20.0, -5.0),
        child: Text("Hello world"),
      ),
    );
  }

  /// RotatedBox和Transform.rotate功能相似，它们都可以对子widget进行旋转变换，
  /// 但是有一点不同：RotatedBox的变换是在layout阶段，会影响在子widget的位置和大小。
  _buildRotatedBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.red),
          //将Transform.rotate换成RotatedBox
          child: RotatedBox(
            quarterTurns: 1, //旋转90度(1/4圈)
            child: Text("Hello world"),
          ),
        ),
        Text(
          "你好",
          style: TextStyle(color: Colors.green, fontSize: 18.0),
        )
      ],
    );
  }

  /// 它是DecoratedBox、ConstrainedBox、Transform、Padding、Align等widget的一个组合widget。
  _buildContainer() {
    return Container(
      //容器内补白
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      //容器外补白
      margin: EdgeInsets.only(top: 5.0, left: 12),
      //卡片大小
      constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0),
      decoration: BoxDecoration(//背景装饰
          gradient: RadialGradient( //背景径向渐变
              colors: [Colors.red, Colors.orange],
              center: Alignment.topLeft,
              radius: .9
          ),
          boxShadow: [ //卡片阴影
            BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0
            )
          ]
      ),
      //卡片倾斜变换
      transform: Matrix4.rotationZ(.2),
      //卡片内文字居中
      alignment: Alignment.center,
      //卡片文字
      child: Text(
        "5.20", style: TextStyle(color: Colors.white, fontSize: 40.0),
      ),
    );
  }
}
