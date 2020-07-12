
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/image_util.dart';

/// 日记底部栏
///
class DiaryItemBottomBar extends StatelessWidget {

  Diary bean;

  DiaryItemBottomBar(this.bean);

  @override
  Widget build(BuildContext context) {
    String icon = Constant.getWeatherIcon(context, bean.weather);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: <Widget>[
          Row(children: <Widget>[
            Text(bean.weekday),
            Gaps.hGap10,
            Text(bean.timeQuantum),
          ]),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    bean.day,
                    style: TextStyle(
                      fontSize: Dimens.font_sp24,
                    ),
                  ),
                  icon != null ?
                  ImageLoader.loadAssetImage(
                    icon,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ) : SizedBox()
                ],
              )),
          Row(children: <Widget>[
            Text("${bean.month}月"),
            Gaps.hGap10,
            Text(bean.year),
          ])
        ],
      ),
    );
  }

}