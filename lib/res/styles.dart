import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'dimens.dart';

class TextStyles {
  static const TextStyle textMain12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.app_main,
  );
  static const TextStyle textMain14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.app_main,
  );
  static const TextStyle textMain16 = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.app_main,
  );
  static const TextStyle textNormal12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_normal,
  );
  static const TextStyle textDark12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_dark,
  );
  static const TextStyle textDark14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_dark,
  );
  static const TextStyle textDark16 = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_dark,
  );
  static const TextStyle textDark24 = TextStyle(
    fontSize: Dimens.font_sp24,
    color: Colours.text_dark,
  );
  static const TextStyle textBoldDark14 = TextStyle(
      fontSize: Dimens.font_sp14,
      color: Colours.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark16 = TextStyle(
      fontSize: Dimens.font_sp16,
      color: Colours.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark18 = TextStyle(
    fontSize: Dimens.font_sp18,
    fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark24 = TextStyle(
      fontSize: 24.0,
      color: Colours.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBoldDark26 = TextStyle(
      fontSize: 26.0,
      color: Colours.text_dark,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textGray10 = TextStyle(
    fontSize: Dimens.font_sp10,
    color: Colours.text_gray,
  );
  static const TextStyle textGray12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
  );
  static const TextStyle textGray14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray,
  );
  static const TextStyle textGray16 = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_gray,
  );
  static const TextStyle textGrayC12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray_c,
  );
  static const TextStyle textGrayC14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray_c,
  );
  static const TextStyle textSmall = TextStyle(
    fontSize: Dimens.font_sp14,
  );
  static const TextStyle textMiddle = TextStyle(
    fontSize: Dimens.font_sp16,
  );
  static const TextStyle textLarge = TextStyle(
    fontSize: Dimens.font_sp18,
  );
  static const TextStyle textMain48 = TextStyle(
    color: Colours.app_main,
    fontSize: Dimens.font_sp48,
  );
  static const TextStyle textMain36 = TextStyle(
    color: Colours.app_main,
    fontSize: Dimens.font_sp36,
  );
  static const TextStyle textMain18 = TextStyle(
    color: Colours.app_main,
    fontSize: Dimens.font_sp18,
  );

  static const TextStyle textNormal = TextStyle(
    fontSize: Dimens.font_sp16,
  );
  static const TextStyle textNormalError = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_red,
  );

  /// 默认字体大小
  static double baseFontSize = 16.0;

  /// 主页内容的bottom bar下的样式
  static TextStyle commonStyle(
      [double multipleFontSize = 1, Color myColor = Colors.lightBlueAccent]) {
    return TextStyle(
        color: myColor,
        fontSize: baseFontSize * multipleFontSize,
        letterSpacing: 1,
        wordSpacing: 2,
        height: 1.2);
  }
}

/// 间隔
class Gaps {
  /// 水平间隔
  static const Widget hGap5 = SizedBox(width: Dimens.gap_dp5);
  static const Widget hGap10 = SizedBox(width: Dimens.gap_dp10);
  static const Widget hGap15 = SizedBox(width: Dimens.gap_dp15);
  static const Widget hGap16 = SizedBox(width: Dimens.gap_dp16);
  static const Widget hGap2 = SizedBox(width: 2.0);
  static const Widget hGap4 = SizedBox(width: 4.0);
  static const Widget hGap8 = SizedBox(width: 8.0);
  static const Widget hGap12 = SizedBox(width: 12.0);

  /// 垂直间隔
  static const Widget vGap5 = SizedBox(height: Dimens.gap_dp5);
  static const Widget vGap10 = SizedBox(height: Dimens.gap_dp10);
  static const Widget vGap15 = SizedBox(height: Dimens.gap_dp15);
  static const Widget vGap50 = SizedBox(height: Dimens.gap_dp50);
  static const Widget vGap2 = SizedBox(height: 2.0);
  static const Widget vGap4 = SizedBox(height: 4.0);
  static const Widget vGap8 = SizedBox(height: 8.0);
  static const Widget vGap12 = SizedBox(height: 12.0);
  static const Widget vGap16 = SizedBox(height: Dimens.gap_dp16);
  static const Widget vGap24 = SizedBox(height: Dimens.gap_dp24);


  static Widget line = Container(height: 0.6, color: Colours.line);
  static Widget vLine = Container(width: 1, height: 20, color: Colours.text_red);
  static Widget lineH = Container(width: 0.6, height: 20, color: Colours.text_red);
  static Widget dividerH = Container(width: 1, height: 16, color: Colours.order_line);
  static Widget divider = Container(width: 1, height: 16, color: Colours.order_line);
  static const Widget empty = SizedBox();
}
