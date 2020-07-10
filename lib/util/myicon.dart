import 'package:flutter/material.dart';

/// 1.导入字体图标文件；这一步和导入字体文件相同，假设我们的字体图标文件保存在项目根目录下，路径为"fonts/iconfont.ttf"：
// fonts:
//  - family: myIcon  #指定一个字体名
//    fonts:
//      - asset: fonts/iconfont.ttf
/// 2.将字体文件中的所有图标都定义成静态变量：
class MyIcons {

  // book 图标
  static const IconData book = const IconData(
      0xe614,
      fontFamily: 'myIcon',
      matchTextDirection: true
  );
  // 微信图标
  static const IconData wechat = const IconData(
      0xec7d,
      fontFamily: 'myIcon',
      matchTextDirection: true
  );
}