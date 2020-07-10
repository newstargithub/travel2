import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/main_page.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/resource_mananger.dart';

class DiaryItem2 extends StatelessWidget {

  final Diary bean; //数据模型

  // 构造函数语法糖，用来给model赋值
  // 将`model.id`作为Item的默认key
  DiaryItem2({this.bean}) : super(key: ValueKey(bean.id));

  @override
  Widget build(BuildContext context) {
    return Card(
      //用Row将左右两部分合体
      child: Container(
        child: Column(children: <Widget>[
          _buildTop(context),
          _buildBottom(context)
        ]),
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
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

  _buildTop(BuildContext context) {
    String envelopePic = bean.envelopePic;
    bool netLink = CommonUtil.isNetLink(envelopePic);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8, 8, 10, 4),
            child: Text(
                bean.envelopeText,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ),
          Gaps.vGap2,
          Stack(
            children: <Widget>[
              netLink
                  ? CachedNetworkImage(
                imageUrl: envelopePic,
                placeholder: (context, url) =>
                    ImageHelper.placeHolder(width: 180, height: 180),
                errorWidget: (context, url, error) =>
                    ImageHelper.error(width: 180, height: 180),
                width: double.infinity,
                height: 160,
                fit: BoxFit.fitWidth,
              ) : Image.file(
                new File(envelopePic),
                width: double.infinity,
                height: 160,
                fit: BoxFit.fitWidth,
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
                        bean.location,
                        style: TextStyles.textGrayC12,
                      )
                    ],
                  ),
              ),
            ],
          ),
        ],
    );
  }
}