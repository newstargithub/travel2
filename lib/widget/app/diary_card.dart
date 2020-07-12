import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/widget/app/diary_item_bottom_bar.dart';
import 'package:roll_demo/widget/app/diary_summary.dart';

/// 此为日记描述类，包括了日记UI中的所有元素
class DiaryCard extends StatelessWidget {

  /// 传入的数据模型
  final Diary bean;

  // 构造函数语法糖，用来给model赋值
  // 将`model.id`作为Item的默认key
  DiaryCard({this.bean}) : super(key: ValueKey(bean.id));

  @override
  Widget build(BuildContext context) {
    return Card(
      //用Row将左右两部分合体
      child: Container(
        child: Column(children: <Widget>[
          DiarySummary(bean),
          DiaryItemBottomBar(bean)
        ]),
      ),
    );
  }


}