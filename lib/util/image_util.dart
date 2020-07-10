import 'package:flutter/material.dart';

import 'util.dart';

/// 加载本地资源图片
Widget loadAssetImage(String name, {double width, double height, BoxFit fit}) {
  return Image.asset(
    Utils.getImgPath(name),
    width: width,
    height: height,
    fit: fit,);
}

/// 加载网络图片
Widget loadNetworkImage(String imageUrl, {String placeholder : "none", double width, double height, BoxFit fit: BoxFit.cover}){
  return Image.network(
    imageUrl,
    width: width,
    height: height,
    fit: fit,
  );
}

/// 图片加载工具类，Image的数据源可以是asset、文件、内存以及网络。
class ImageLoader {
  /// 加载本地资源图片
  static Widget loadAssetImage(String name, {double width, double height, BoxFit fit}) {
    return Image.asset(
      Utils.getImgPath(name),
      width: width,
      height: height,
      fit: fit,);
  }

  /// 加载网络图片
  static Widget loadNetworkImage(String imageUrl, {String placeholder : "none", double width, double height, BoxFit fit: BoxFit.cover}){
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
    );
  }
}




