import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FocusTestRoute extends StatefulWidget {
  @override
  _FocusTestRouteState createState() => new _FocusTestRouteState();
}

class _FocusTestRouteState extends State<FocusTestRoute> {
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusScopeNode focusScopeNode;

  int a = 0;

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text("TextAlign",
                  textAlign: a == 0 ? TextAlign.start : TextAlign.end,
                ),
              ),
            Container(
              width: double.infinity,
              child: TextField(
                  autofocus: true,
                  textAlign: a == 0 ? TextAlign.start : TextAlign.end,
                  focusNode: focusNode1,//关联focusNode1
                  decoration: InputDecoration(
                      labelText: "input1"
                  ),
                )
            ),
              TextField(
                textAlign: TextAlign.end,
                focusNode: focusNode2,//关联focusNode2
                decoration: InputDecoration(
                    labelText: "input2"
                ),
              ),
              Builder(builder: (ctx) {
                return Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("移动焦点"),
                      onPressed: () {
                        //将焦点从第一个TextField移到第二个TextField
                        // 这是一种写法 FocusScope.of(context).requestFocus(focusNode2);
                        // 这是第二种写法
                        if(null == focusScopeNode){
                          focusScopeNode = FocusScope.of(context);
                        }
                        focusScopeNode.requestFocus(focusNode2);
                      },
                    ),
                    RaisedButton(
                      child: Text("隐藏键盘"),
                      onPressed: () {
                        // 当所有编辑框都失去焦点时键盘就会收起
                        focusNode1.unfocus();
                        focusNode2.unfocus();
                      },
                    ),
                    RaisedButton(
                      child: Text("对齐"),
                      onPressed: () {
                        if(a == 0) {
                          a = 1;
                        } else {
                          a = 0;
                        }
                        setState(() {

                        });
                      },
                    ),
                  ],
                );
              },
              ),
            ],
          ),
        ),
      );
  }

}