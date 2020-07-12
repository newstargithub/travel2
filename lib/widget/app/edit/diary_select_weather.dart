
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';

import '../../BottomSheetAction.dart';
import '../../store_select_text_item.dart';

class DiarySelectWeather extends StatelessWidget {

  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return StoreSelectTextItem(
      textAlign: TextAlign.end,
      title: S.of(context).weather,
      content: model.weather,
      onTap: () {
        _onTapSelectWeather(context);
      },
    );
  }

  /// 天气选择
  Future _onTapSelectWeather(BuildContext context) async {
    debugPrint("天气选择弹窗");
    //"fine", "rain", "snow", "cloudy", "overcast"
    showSelectDialog(context, Constant.getWeatherTextList(context));
  }

  void showSelectDialog(BuildContext context, List<String> list) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    var theme = Theme.of(context);
    int indexSelected = 0;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheetAction(
            child: Container(
              height: 200,
              child: CupertinoPicker.builder(
                backgroundColor: theme.dialogBackgroundColor,
                itemExtent: 50,
                //item的高度
                onSelectedItemChanged: (index) {
                  print("天气index = $index");
                  indexSelected = index;
                },
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      list[index],
                    ),
                  );
                },
                childCount: list.length,
              ),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
              _selectWeather(model, list[indexSelected]);
            },
          );
        }
    );
  }

}

void _selectWeather(DiaryModel model, String weather) {
  model.setWeather(weather);
}