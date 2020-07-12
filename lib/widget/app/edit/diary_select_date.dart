
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/ui/page/diary/diary_model.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';

import '../../BottomSheetAction.dart';
import '../../store_select_text_item.dart';

class DiarySelectDate extends StatelessWidget {

  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DiaryModel>(context);
    return StoreSelectTextItem(
      textAlign: TextAlign.end,
      title: S.of(context).time,
      content: model.date?? "",
      onTap: () {
        _onTapSelectTime(context);
      },
    );
  }

  /// 时间选择
  void _onTapSelectTime(BuildContext context) {
    DiaryModel model = Provider.of<DiaryModel>(context);
    DateTime nowTime = DateTime.now();
    DateTime dateTime = model.dateTime ?? nowTime;
    DateTime date = nowTime;
    DateTime time = nowTime;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheetAction(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (dateTime) {
                        debugPrint("时间onDateTimeChanged:$dateTime");
                        date = dateTime;
                      },
                      minimumYear: 1960,
                      //最小年份，只有mode为date时有效
                      maximumYear: nowTime.year,
                      maximumDate: nowTime,
                      initialDateTime: dateTime,
                    ),
                  ),
                  Container(
                    height: 150,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (dateTime) {
                        debugPrint("时间onDateTimeChanged:$dateTime");
                        time = dateTime;
                      },
                      maximumDate: nowTime,
                      initialDateTime: dateTime,
                      use24hFormat: false,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
              _selectDateTime(model, date, time);
            },
          );
        });
  }

  //设置选择时间
  void _selectDateTime(DiaryModel model, DateTime date, DateTime time) {
    DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second, time.millisecond);
    model.setDateTime(dateTime);
  }

}
