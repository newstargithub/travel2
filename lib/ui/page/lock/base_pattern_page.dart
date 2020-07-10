
import 'package:flutter/material.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/resources.dart';
import 'package:roll_demo/ui/page/lock/set_pattern_model.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/lock/pattern_lock.dart';

import 'PatternLockUtils.dart';


const int PATTERN_SUCCESS = -1;
const int CANCELLED = 0;
const int INVALID = 1;
const int PATTERN_FORGOT = 2;

class BasePatternWidget extends StatefulWidget {
  String title = "设置手势密码";

  @override
  State<StatefulWidget> createState() {
    return _BasePatternState();
  }

  /// 保存设置手势
  void onSetPattern(String pattern) {
    PatternLockUtils.setPattern(pattern);
  }

  /// 确认完成
  void onConfirmed(BuildContext context) {
    NavigatorUtils.goBackWithParams(context, PATTERN_SUCCESS);
  }

  /// 忘记密码
  void onForgotPin(BuildContext context) {
    NavigatorUtils.goBackWithParams(context, PATTERN_FORGOT);
  }

  /// 取消设置
  void onCanceled(BuildContext context) {
    NavigatorUtils.goBackWithParams(context, CANCELLED);
  }

}

class _BasePatternState extends State<BasePatternWidget> {
  var mPattern;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ProviderWidget<SetPatternModel>(
        model: SetPatternModel(context),
        onModelReady: (model) {
          model.updateStage(Stage.Draw, context);
        },
        builder: (context, SetPatternModel model, child) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: Column(
              children: <Widget>[
                Text(
                  model.errorMsg?? "",
                  style: model.isError? TextStyles.textNormalError : TextStyles.textNormal,
                ),
                Gaps.vGap24,
                Expanded(
                  flex: 1,
                  child:  Container(
                    alignment: Alignment.topCenter,
                    child: PatternLock(
                      dotCount: 3,
                      minLinkDotCount: model.minPatternSize,
                      onComplete: (List<Dot> pattern) {
                        _onPatternComplete(model, pattern);
                      },
                    ),
                  ),
                ),
                Gaps.line,
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:
                      FlatButton(
                        child: Text(model.leftText??""),
                        onPressed: model.enableLeft? ()=> onPressedLeft(model) : null,
                      ),
                    ),
                    Gaps.lineH,
                    Expanded(
                      flex: 1,
                      child:
                      FlatButton(
                        child: Text(model.rightText??""),
                        onPressed: model.enableRight? ()=> onPressedRight(model) : null,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      )
    );
  }

  /// 手势出错
  _onPatternError(SetPatternModel model, StateCode code) {
    updateStage(model, Stage.DrawTooShort);
  }

  /// 手势完成
  _onPatternComplete(SetPatternModel model, List<Dot> pattern) {
    StringBuffer sb = StringBuffer();
    for(Dot dot in pattern) {
      sb.write(dot.value);
    }
    String newPattern = sb.toString();
    debugPrint("绘制的手势密码：$newPattern");
    switch (model.mStage) {
      case Stage.Draw:
      case Stage.DrawTooShort:
        if (pattern.length < model.minPatternSize) {
          updateStage(model, Stage.DrawTooShort);
        } else {
          mPattern = newPattern;
//          updateStage(model, Stage.DrawValid);
          // 不需要点按钮，直接确认
          updateStage(model, Stage.Confirm);
        }
        break;
      case Stage.Confirm:
      case Stage.ConfirmWrong:
        debugPrint("上次绘制的手势密码：$mPattern");
        if (newPattern == mPattern) {
          updateStage(model, Stage.ConfirmCorrect);
          widget.onSetPattern(mPattern);
          widget.onConfirmed(context);
        } else {
          updateStage(model, Stage.ConfirmWrong);
        }
        break;
      case Stage.DrawValid:
        break;
      case Stage.ConfirmCorrect:
        break;
    }
  }

  /// 点左边按钮
  void onPressedLeft(SetPatternModel model) {
    if (model.leftButtonState == LeftButtonState.Redraw) {
      mPattern = null;
      updateStage(model, Stage.Draw);
    } else if (model.leftButtonState == LeftButtonState.Cancel) {
      widget.onCanceled(model.context);
    }
  }

  /// 点右边按钮
  void onPressedRight(SetPatternModel model) {
    if (model.rightButtonState == RightButtonState.Continue) {
      if (model.mStage == Stage.DrawValid) {
        updateStage(model, Stage.Confirm);
      } else {
        debugPrint("expected ui stage ${Stage.DrawValid} when button is RightButtonState.Continue");
      }
    } else if (model.rightButtonState == RightButtonState.Confirm) {
      if (model.mStage == Stage.ConfirmCorrect) {
        widget.onSetPattern(mPattern);
        widget.onConfirmed(context);
      } else {
        debugPrint("expected ui stage Stage.ConfirmCorrect when button is RightButtonState.Confirm");
      }
    }
  }

  void updateStage(SetPatternModel model, Stage newStage) {
    model.updateStage(newStage, context);
  }

}

enum Stage {
  Draw,
  DrawTooShort,
  /// 有效
  DrawValid,
  Confirm,
  ConfirmWrong,
  ConfirmCorrect
}

enum LeftButtonState{
  Cancel,
  Redraw
}

enum RightButtonState{
  Continue,
  ContinueDisabled,
  Confirm,
  ConfirmDisabled
}