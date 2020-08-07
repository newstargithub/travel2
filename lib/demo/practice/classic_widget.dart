import 'package:flutter/material.dart';

class ClassicWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClassicWidgetState();
  }
}

class _ClassicWidgetState extends State<ClassicWidget> {
  @override
  Widget build(BuildContext context) {
    TextStyle styleRed =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20);
    TextStyle styleBlack = TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20);
    return Column(
      children: <Widget>[
        Text(
          "Text是文本控件",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
        ),

        //富文本
        Text.rich(
          TextSpan(children: [
            TextSpan(text: "Text是文本控件", style: styleRed),
            TextSpan(text: "类似Android中的TextView", style: styleBlack),
          ]),
          textAlign: TextAlign.center,
        ),

        //FadeInImage 控件提供了图片占位的功能，并且支持在在图片加载完成时淡入淡出的视觉效果
        //想要支持缓存到文件系统，可以使用第三方的CachedNetworkImage控件
        FadeInImage.assetNetwork(
          placeholder: "assets/loading.gif",
          image: "http://xxx.jpg",
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),

        //圆形的按钮
        FloatingActionButton(
          child: Text("Btn"),
          onPressed: ()=>print("FloatingActionButton onPressed"),
        ),

        //扁平化的按钮
        FlatButton(
          child: Text("Btn"),
          onPressed: ()=>print("FlatButton onPressed"),
        ),

        //凸起的按钮
        RaisedButton(
          child: Text("Btn"),
          onPressed: ()=>print("RaisedButton onPressed"),
        ),
      ],
    );
  }
}
