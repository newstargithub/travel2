
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/app/edit/diary_select_weather.dart';

import 'diary_select_date.dart';
import 'diary_select_labels.dart';
import 'diary_select_location.dart';

/// 文章的额外信息组件
///
/// 包括时间，地点，天气
/// 需要外部参数[address],地点
class DiarySetExtraInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Gaps.vGap16,
        DiarySelectWeather(),
        DiarySelectDate(),
        DiarySelectLocation(),
        DiarySelectLabels(),
        Gaps.vGap16,
      ],
    );
  }






}