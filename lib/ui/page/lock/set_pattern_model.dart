import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/widget/lock/DisplayMode.dart';

import 'base_pattern_page.dart';

class SetPatternModel extends ViewStateModel {
  Stage mStage = Stage.Draw;

  LeftButtonState leftButtonState;

  RightButtonState rightButtonState;

  bool patternEnabled = true;

  String errorMsg;

  String leftText;

  bool enableLeft = true;

  String rightText;

  bool enableRight = true;

  bool isClearPattern;

  DisplayMode mDisplayMode;

  int minPatternSize = 4;

  bool isError = false;

  BuildContext context;

  SetPatternModel(this.context);

  void updateStage(Stage newStage, context) {
    mStage = newStage;
    switch (mStage) {
      case Stage.Draw:
      // clearPattern() resets display mode to DisplayMode.Correct.
        errorMsg = "绘制解锁图案";
        isError = false;
        _setLeftButtonState(LeftButtonState.Cancel, context);
        _setRightButtonState(RightButtonState.ContinueDisabled, context);
        clearPattern();
        break;
      case Stage.DrawTooShort:
        errorMsg = "至少连接 $minPatternSize 个点，请重画";
        isError = true;
        _setLeftButtonState(LeftButtonState.Redraw, context);
        _setRightButtonState(RightButtonState.ContinueDisabled, context);
        setDisplayMode(DisplayMode.Wrong);
        postClearPatternRunnable();
        break;
      case Stage.DrawValid:
        errorMsg = "已记录图案";
        isError = false;
        _setLeftButtonState(LeftButtonState.Redraw, context);
        _setRightButtonState(RightButtonState.Continue, context);
        break;
      case Stage.Confirm:
        errorMsg = "再次绘制图案以确认";
        isError = false;
        _setLeftButtonState(LeftButtonState.Cancel, context);
        _setRightButtonState(RightButtonState.ConfirmDisabled, context);
        clearPattern();
        break;
      case Stage.ConfirmWrong:
        errorMsg = "图案错误，请重试";
        isError = true;
        setDisplayMode(DisplayMode.Wrong);
        postClearPatternRunnable();
        break;
      case Stage.ConfirmCorrect:
        errorMsg = "您的新解锁图案";
        isError = false;
        break;
    }
    notifyListeners();
  }

  void _setLeftButtonState(LeftButtonState state, context) {
    leftButtonState = state;
    if(state == LeftButtonState.Redraw) {
      leftText = "重画";
      enableLeft = true;
    } else {
      leftText = S.of(context).cancel;
      enableLeft = true;
    }
  }

  void _setRightButtonState(RightButtonState state, context) {
    rightButtonState = state;
    if(state == RightButtonState.ContinueDisabled) {
      rightText = S.of(context).pl_continue;
      enableRight = false;
    } else if(state == RightButtonState.Confirm) {
      rightText = S.of(context).confirm;
      enableRight = true;
    } else if(state == RightButtonState.ConfirmDisabled) {
      rightText = S.of(context).confirm;
      enableRight = false;
    } else {
      rightText = S.of(context).pl_continue;
      enableRight = false;
    }
  }

  /// 清理手势
  void clearPattern() {
    isClearPattern = true;
  }

  /// 投递清理手势延时任务
  void postClearPatternRunnable() {
    const timeout = const Duration(seconds: 2);
    Timer(timeout, clearPattern);
  }

  void setDisplayMode(DisplayMode displayMode) {
    mDisplayMode = displayMode;
  }



}