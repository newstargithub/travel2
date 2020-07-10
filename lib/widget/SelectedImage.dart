import 'dart:io';

import 'package:flutter/material.dart';
import 'package:roll_demo/util/util.dart';

class SelectedImage extends StatelessWidget {
  final File image;

  final VoidCallback onTap;

  final double size;

  const SelectedImage({Key key, this.image, this.onTap, this.size = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            // 图片圆角展示
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
                image: image == null
                    ? AssetImage(Utils.getImgPath("store/icon_zj"))
                    : FileImage(image),
                fit: BoxFit.cover)),
      ),
    );
  }
}
