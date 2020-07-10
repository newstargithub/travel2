import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/main_page.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/resource_mananger.dart';

class DiaryItem extends StatelessWidget {

  final Diary model; //数据模型

  // 构造函数语法糖，用来给model赋值
  // 将`model.id`作为Item的默认key
  DiaryItem({this.model}) : super(key: ValueKey(model.id));

  @override
  Widget build(BuildContext context) {
    return Card(
      //用Row将左右两部分合体
      child: Container(
        child: Row(children: <Widget>[
          buildLeftColumn(context),
          _buildRightColumn(context)
        ]),
        height: 200,
      ),
    );
  }

  Widget buildLeftColumn(BuildContext context) {
    var icon = Constant.getWeatherIcon(context, model.weather);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Text(model.weekday),
            Gaps.hGap10,
            Text(model.timeQuantum),
          ]),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    model.day,
                    style: TextStyle(
                      fontSize: Dimens.font_sp24,
                    ),
                  ),
                  ImageLoader.loadAssetImage(
                    icon,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                ],
              )),
          Row(children: <Widget>[
            Text(model.month),
            Gaps.hGap10,
            Text(model.year),
          ])
        ],
      ),
    );
  }

  _buildRightColumn(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: model.envelopePic,
                placeholder: (context, url) =>
                    ImageHelper.placeHolder(width: 180, height: 180),
                errorWidget: (context, url, error) =>
                    ImageHelper.error(width: 180, height: 180),
                width: 245,
                height: 180,
                fit: BoxFit.cover,
              ),
              Positioned(
                  left: 2.0,
                  bottom: 2.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).accentColor,
                        size: 16,
                      ),
                      Text(
                        model.location,
                        style: TextStyles.textGrayC12,
                      )
                    ],
                  )),
            ],
          ),
          Gaps.vGap2,
          Text(
            model.envelopeText,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}