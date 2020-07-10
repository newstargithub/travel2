import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/widget/lock/pattern_lock.dart';

import 'base_pattern_page.dart';
import 'confirm_pattern_model.dart';

abstract class BaseConfirmPattern extends StatefulWidget {
  String title = "验证手势密码";

  @override
  State<StatefulWidget> createState() {
    return _BaseConfirmPatternState();
  }

  Future<bool> isPatternCorrect(String pattern);

  void onConfirmed(BuildContext context);

  void onForgotPassword(BuildContext context);

  void onPatternCancel(BuildContext context);

}

class _BaseConfirmPatternState extends State<BaseConfirmPattern> {
  var mNumFailedAttempts = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ProviderWidget<ConfirmPatternModel>(
          model: ConfirmPatternModel(context),
          onModelReady: (ConfirmPatternModel model) {
            model.init();
          },
          builder: (context, ConfirmPatternModel model, child) {
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

  Future _onPatternComplete(ConfirmPatternModel model, List<Dot> pattern) async {
    StringBuffer sb = StringBuffer();
    for(Dot dot in pattern) {
      sb.write(dot.value);
    }
    String newPattern = sb.toString();
    debugPrint("绘制的手势密码：$newPattern");
    bool isCorrect = await widget.isPatternCorrect(newPattern);
    if(isCorrect) {
      widget.onConfirmed(context);
    } else {
      model.onWrongPattern();
      onWrongPattern();
    }
  }

  void onWrongPattern() {
    ++ mNumFailedAttempts;
  }

  onPressedLeft(ConfirmPatternModel model) {
    widget.onPatternCancel(context);
  }

  onPressedRight(ConfirmPatternModel model) {
    widget.onForgotPassword(context);
  }
}