
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/resource_mananger.dart';
/// 日记概要信息
class DiarySummary extends StatelessWidget{

  Diary bean;

  DiarySummary(this.bean);

  @override
  Widget build(BuildContext context) {

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
            _buildEnvelopeImage(bean.envelopePic),
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

  /// 封面图片
  _buildEnvelopeImage(String imageUrl) {
    bool netLink = CommonUtil.isNetLink(imageUrl);
    return netLink
        ? CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          ImageHelper.placeHolder(width: 180, height: 180),
      errorWidget: (context, url, error) =>
          ImageHelper.error(width: 180, height: 180),
      width: double.infinity,
      height: 160,
      fit: BoxFit.fitWidth,
    ) : Image.file(
      new File(imageUrl),
      width: double.infinity,
      height: 160,
      fit: BoxFit.fitWidth,
    );
  }

}