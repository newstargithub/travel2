import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/resource_mananger.dart';

class ItemImage extends StatelessWidget {

  final CustomTypeList item;
  final bool isEdit;
  final VoidCallback onPressed;
  final VoidCallback onDeletePressed;

  ItemImage(this.item, {this.isEdit,
    this.onPressed,
    this.onDeletePressed
  });

  /// 对齐方式
  AlignmentGeometry _getAlign(CustomTypeList item) {
    AlignmentGeometry alignment = AlignmentDirectional.center;
    if (item.alignment == TypeAlignment.left) {
      alignment = AlignmentDirectional.topStart;
    } else if (item.alignment == TypeAlignment.right) {
      alignment = AlignmentDirectional.topEnd;
    }
    return alignment;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              child: _buildImage(),
              onTap: onPressed,
            )
        ),
        _buildDeleteButton(),
      ],
    );
  }

  /// 图片
  _buildImage() {
    bool netLink = CommonUtil.isNetLink(item.data);
    return netLink
        ? CachedNetworkImage(
      imageUrl: item.data,
      placeholder: (context, url) =>
          ImageHelper.placeHolder(width: 180, height: 180),
      errorWidget: (context, url, error) =>
          ImageHelper.error(width: 180, height: 180),
      fit: BoxFit.cover,
    ) : Image.file(new File(item.data));
  }

  /// 删除按钮
  _buildDeleteButton() {
    return isEdit ?
    Positioned(
      top: -2,
      right: 6,
      //Container是DecoratedBox、ConstrainedBox、Transform、Padding、Align等组件组合的一个多功能容器
      child: Container(
        width: 24,
        height: 24,
        child: IconButton(
            icon: Icon(Icons.cancel),
            iconSize: 24.0,
            padding: const EdgeInsets.all(0.0),
            color: Colors.red,
            onPressed: onDeletePressed
        ),
      ),
    ) : SizedBox();
  }

}