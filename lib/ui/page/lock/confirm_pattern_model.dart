
import 'package:flutter/src/widgets/framework.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';

class ConfirmPatternModel extends ViewStateModel {
  var context;

  var errorMsg;

  var isError = false;

  var minPatternSize = 3;

  var leftText;

  var enableLeft = true;

  var rightText;

  var enableRight = true;

  ConfirmPatternModel(this.context);

  void init() {
    errorMsg = "绘制图案以解锁";
    leftText = S.of(context).cancel;
    rightText = "忘记图案";
  }

  void onWrongPattern() {
    errorMsg = "图案错误，请重试";
    isError = true;
    notifyListeners();
  }

}