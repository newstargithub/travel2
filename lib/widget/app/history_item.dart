
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/resource_mananger.dart';
import 'package:roll_demo/util/route.dart';

const double _kItemImageHeight = 80.0;

class HistoryItem extends StatelessWidget {

  //数据模型
  final Diary bean;

  GestureTapCallback onTap;

  bool showDateHeader;

  double imageHeight;

  // 构造函数语法糖，用来给model赋值
  HistoryItem({
    this.bean,
    this.onTap,
    this.showDateHeader,
    this.imageHeight = _kItemImageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
            offstage: !showDateHeader,
            child: Container(
              color: Theme.of(context).dialogBackgroundColor,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(bean.yearAndMonth,
                  style: TextStyles.textLarge,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onTap ??
            () {
              debugPrint("onTap itemId=${bean.id}");
              NavigatorUtils.pushNamed(context, DIARY_DETAIL_PAGE, arguments: bean.id);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: imageHeight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Expanded(
                          child: Text(bean.envelopeText,
                          style: TextStyles.textMiddle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildSecondaryInfo(bean),
                        ],
                      ),
                    ),
                  ),
                  Gaps.hGap5,
                  _buildEnvelopeImg(bean),
                ],
              ),
            ),
          ),
        ]
    );
  }

  _buildEnvelopeImg(Diary bean) {
    String envelopePic = bean.envelopePic;
    bool netLink = CommonUtil.isNetLink(envelopePic);
    if(CommonUtil.isEmpty(envelopePic)) {
      return SizedBox();
    } else {
      return netLink
          ? CachedNetworkImage(
        imageUrl: envelopePic,
        placeholder: (context, url) =>
            ImageHelper.placeHolder(width: 180, height: 180),
        errorWidget: (context, url, error) =>
            ImageHelper.error(width: 180, height: 180),
        width: imageHeight,
        height: imageHeight,
        fit: BoxFit.fitWidth,
      ) : Image.file(
        File(envelopePic),
        width: imageHeight,
        height: imageHeight,
        fit: BoxFit.fitWidth,
      );
    }
  }

  Widget _buildSecondaryInfo(Diary bean) {
    return Row(
      children: <Widget>[
        Text(bean.date?? "",
          style: TextStyles.textGray14,
        ),
        Gaps.hGap16,
        Text(bean.weather?? "",
          style: TextStyles.textGray14,
        ),
        Gaps.hGap16,
        Expanded(
          child: Text(bean.location?? "",
            style: TextStyles.textGray14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

}