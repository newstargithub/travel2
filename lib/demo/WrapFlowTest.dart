
import 'package:flutter/material.dart';

///把超出屏幕显示范围会自动折行的布局称为流式布局。
///Flutter中通过Wrap和Flow来支持流式布局
/// No Material widget found.
//I/flutter (25517): ListTile widgets require a Material widget ancestor.
//使用了Material 风格的widget 就需要Scaffold作为根布局
class WrapFlowTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WrapFlowTestState();
  }
}

class _WrapFlowTestState extends State<WrapFlowTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          direction: Axis.horizontal,
          spacing: 8, // 主轴(水平)方向间距
          runSpacing: 4, // 纵轴（垂直）方向间距
          alignment: WrapAlignment.center, //沿主轴方向居中
          children: <Widget>[
            Chip(
              avatar: new CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
              label: new Text('Hamilton'),
            ),
            Chip(
              avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text("M")),
              label: Text("Lafayette"),
            ),
            Chip(
              avatar: new CircleAvatar(backgroundColor: Colors.blue, child: Text('H')),
              label: new Text('Mulligan'),
            ),
            Chip(
              avatar: CircleAvatar(backgroundColor: Colors.black, child: Text("J")),
              label: Text("Laurens"),
            ),
          ],
        ),
        Flow(
          delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              color: Colors.red,
            ),
            Container(
              width: 80,
              height: 80,
              color: Colors.green,
            ),
            Container(
              width: 80,
              height: 80,
              color: Colors.blue,
            ),
            Container(width: 80.0, height:80.0,  color: Colors.yellow,),
            new Container(width: 80.0, height:80.0, color: Colors.brown,),
            new Container(width: 80.0, height:80.0,  color: Colors.purple,),
          ],
        )
      ],
    );
  }
}

class TestFlowDelegate  extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;

  TestFlowDelegate({this.margin});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for(int i = 0; i < context.childCount; i++) {
      var childSize = context.getChildSize(i);
      var w = childSize.width + x + margin.right;
      if(w < context.size.width) {
        //本行剩余空间够
        context.paintChild(i,
          transform: Matrix4.translationValues(x, y, 0.0),
        );
        x = w + margin.left;
      } else {
        x = margin.left;
        y += childSize.height + margin.bottom + margin.top;
        context.paintChild(i,
          transform: Matrix4.translationValues(x, y, 0.0),
        );
        x += childSize.width + margin.right + margin.left;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return Size(double.infinity,200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}