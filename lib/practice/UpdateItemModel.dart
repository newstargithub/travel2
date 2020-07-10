import 'package:flutter/material.dart';

class UpdateItemModel {
  String appIcon; //App 图标
  String appName; //App 名称
  String appSize; //App 大小
  String appDate; //App 更新日期
  String appDescription; //App 更新文案
  String appVersion; //App 版本
  // 构造函数语法糖，为属性赋值
  UpdateItemModel(
      {this.appIcon,
      this.appName,
      this.appSize,
      this.appDate,
      this.appDescription,
      this.appVersion});
}

/// 通过组装去自定义控件
class UpdatedItem extends StatelessWidget {
  final UpdateItemModel model;
  final VoidCallback onPressed;

  UpdatedItem({Key key, this.model, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[buildTopRow(context), buildBottomRow(context)],
    );
  }

  Widget buildTopRow(BuildContext context) {
    return Row(//Row 控件，用来水平摆放子 Widget
        children: <Widget>[
      Padding(
          //Paddng 控件，用来设置 Image 控件边距
          padding: EdgeInsets.all(10), // 上下左右边距均为 10
          child: ClipRRect(
              // 圆角矩形裁剪控件
              borderRadius: BorderRadius.circular(8.0), // 圆角半径为 8
              child: Image.asset(model.appIcon, width: 80, height: 80) //图片控件
              )),
      Expanded(
        //Expanded 控件，用来拉伸中间区域
        child: Column(
          //Column 控件，用来垂直摆放子 Widget
          mainAxisAlignment: MainAxisAlignment.center, // 垂直方向居中对齐
          crossAxisAlignment: CrossAxisAlignment.start, // 水平方向居左对齐
          children: <Widget>[
            Text(model.appName, maxLines: 1), //App 名字
            Text(model.appDate, maxLines: 1), //App 更新日期
          ],
        ),
      ),
      Padding(
          //Paddng 控件，用来设置 Widget 间边距
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0), // 右边距为 10，其余均为 0
          child: FlatButton(
            // 按钮控件
            child: Text("OPEN"),
            onPressed: onPressed, // 点击回调
          ))
    ]);
  }

  Widget buildBottomRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(model.appDescription),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("${model.appDate}.${model.appSize} MB"),
          ),
        ],
      ),
    );
  }
}
